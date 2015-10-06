# encoding: UTF-8
# Cookbook Name:: bareos
# Recipe:: server
#
# Copyright (C) 2014 Leonard TAVAE
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# By default here including both the repo and client recipes
include_recipe 'chef-bareos'

# Preparing Random Password for the director and mon, including OpenSSL library from client.rb
node.set_unless['bareos']['dir_password'] = random_password(length: 30, mode: :base64)
node.set_unless['bareos']['mon_password'] = random_password(length: 30, mode: :base64)
node.save unless Chef::Config[:solo]

# Install BAREOS Server Packages
%w( bareos-director bareos-tools ).each do |server_pkgs|
  package server_pkgs do
    action :install
  end
end

# Create hosts directory for host configs
directory '/etc/bareos/bareos-dir.d/clients/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Create a placeholder file so BAREOS doesn't throw error when none found
file '/etc/bareos/bareos-dir.d/_recipe_complete.conf' do
  content '# This is a base file so the recipe works with no additional help'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Create necessary bareos-dir config
template '/etc/bareos/bareos-dir.conf' do
  source 'bareos-dir.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    db_driver: node['bareos']['database']['dbdriver'],
    db_name: node['bareos']['database']['dbname'],
    db_user: node['bareos']['database']['dbuser'],
    db_password: node['bareos']['database']['dbpassword'],
    db_address: node['bareos']['database']['dbaddress']
  )
  notifies :run, 'execute[reload-dir]', :delayed
end

# Handle seperate host config files
# Populate host config files based on:
#  * the default['bareos']['clients']['client_list'] attribute
#   - OR -
#  * hosts with bareos_client role attached
if Chef::Config[:solo]
  bareos_clients = node['bareos']['clients']['client_list']
else
  bareos_clients = search(:node, 'roles:bareos_client')
end

# Account for any number of clients, setup the client config on the director machine
# Also push out whether to do custom client pools in chef-solo or chef-client mode
bareos_clients.each do |client|
  template "/etc/bareos/bareos-dir.d/clients/#{client['fqdn']}.conf" do
    source 'client.conf.erb'
    owner 'bareos'
    group 'bareos'
    mode '0640'
    variables(
      bareos_client: client
    )
    notifies :run, 'execute[reload-dir]', :delayed
  end
end

# Allow a restart of the director daemon if called with tests up front
execute 'reload-dir' do
  command 'su - bareos -s /bin/sh -c "/usr/sbin/bareos-dir -t -c /etc/bareos/bareos-dir.conf"'
  action :nothing
  notifies :restart, 'service[bareos-dir]', :delayed
end

# Enable and start the bareos-dir service
service 'bareos-dir' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
