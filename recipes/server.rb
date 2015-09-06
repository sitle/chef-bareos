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

# Preparing Random Password for the director and mon
node.set_unless['bareos']['dir_password'] = random_password(length: 30, mode: :base64)
node.set_unless['bareos']['mon_password'] = random_password(length: 30, mode: :base64)
node.save unless Chef::Config[:solo]

# Install BAREOS Server Packages
%w( bareos-director bareos-tools ).each do |server_pkgs|
  package server_pkgs do
    action :install
  end
end

if Chef::Config[:solo]
  bareos_clients = node['bareos']['clients']
else
  bareos_clients = search(:node, 'roles:bareos_client')
end

# Create hosts direcotry for host configs
directory '/etc/bareos/bareos-dir.d/clients/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Handle seperate host config files
# Populate host config files based on:
#  * with values from the default['bareos']['clients'] attribute
#   - OR -
#  * hosts with bareos_client role attached
bareos_clients.each do |client|
  if Chef::Config[:solo]
    template '/etc/bareos/bareos-dir.conf' do
      source 'bareos-dir.conf.erb'
      owner 'bareos'
      group 'bareos'
      mode '0640'
      variables(
        db_driver: node['bareos']['dbdriver'],
        db_name: node['bareos']['dbname'],
        db_user: node['bareos']['dbuser'],
        db_password: node['bareos']['dbpassword'],
        db_address: node['bareos']['dbaddress'],
        client_full_pool: "#{client}-Full-Pool",
        client_inc_pool: "#{client}-Inc-Pool",
        client_diff_pool: "#{client}-Diff-Pool"
      )
      notifies :run, 'execute[reload-dir]', :delayed
    end
    template "/etc/bareos/bareos-dir.d/clients/#{client}.conf" do
      source 'client.conf.erb'
      owner 'bareos'
      group 'bareos'
      mode '0640'
      variables(
        bareos_client: client,
        client_full_pool: "#{client}-Full-Pool",
        client_inc_pool: "#{client}-Inc-Pool",
        client_diff_pool: "#{client}-Diff-Pool"
      )
      notifies :run, 'execute[reload-dir]', :delayed
    end
  else
    template '/etc/bareos/bareos-dir.conf' do
      source 'bareos-dir.conf.erb'
      owner 'bareos'
      group 'bareos'
      mode '0640'
      variables(
        db_driver: node['bareos']['dbdriver'],
        db_name: node['bareos']['dbname'],
        db_user: node['bareos']['dbuser'],
        db_password: node['bareos']['dbpassword'],
        db_address: node['bareos']['dbaddress'],
        client_full_pool: "#{client['hostname']}-Full-Pool",
        client_inc_pool: "#{client['hostname']}-Inc-Pool",
        client_diff_pool: "#{client['hostname']}-Diff-Pool"
      )
      notifies :run, 'execute[reload-dir]', :delayed
    end
    template "/etc/bareos/bareos-dir.d/clients/#{client['hostname']}.conf" do
      source 'client.conf.erb'
      owner 'bareos'
      group 'bareos'
      mode '0640'
      variables(
        bareos_client: client['hostname'],
        client_full_pool: "#{client['hostname']}-Full-Pool",
        client_inc_pool: "#{client['hostname']}-Inc-Pool",
        client_diff_pool: "#{client['hostname']}-Diff-Pool"
      )
      notifies :run, 'execute[reload-dir]', :delayed
    end
  end
end

execute 'reload-dir' do
  command 'su - bareos -s /bin/sh -c "/usr/sbin/bareos-dir -t -c /etc/bareos/bareos-dir.conf"'
  action :nothing
  notifies :restart, 'service[bareos-dir]', :delayed
end

service 'bareos-dir' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
