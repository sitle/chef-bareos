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
# This is just so Bareos has SOMETHING to backup (i.e. Catalog)
include_recipe 'chef-bareos::client'

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

# Create the core config for the Director
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
    db_address: node['bareos']['database']['dbaddress'],
    dir_name: node['bareos']['director']['name']
  )
end
file '/etc/bareos/bareos-dir.d/.conf' do
  content '# This is a base file so the recipe works with no additional help'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Create clients config based on sets of hashes, see attributes file for default example(s)
client_search_query = node['bareos']['clients']['client_search_query']

if Chef::Config[:solo]
  bareos_clients = node['bareos']['clients']['client_list']
else
  bareos_clients = search(:node, client_search_query)
end
template '/etc/bareos/bareos-dir.d/clients.conf' do
  source 'clients.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    bareos_clients: bareos_clients,
    client_conf: node['bareos']['clients']['conf']
  )
end

# Create other various configs based on sets of hashes
template '/etc/bareos/bareos-dir.d/jobs.conf' do
  source 'jobs.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    bareos_clients: bareos_clients,
    client_jobs: node['bareos']['clients']['jobs']
  )
end
template '/etc/bareos/bareos-dir.d/job_definitions.conf' do
  source 'job_definitions.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    job_definitions: node['bareos']['clients']['job_definitions']
  )
end
template '/etc/bareos/bareos-dir.d/filesets.conf' do
  source 'filesets.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    fileset_config: node['baroes']['clients']['filesets']
  )
end
template '/etc/bareos/bareos-dir.d/pools.conf' do
  source 'pools.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    client_pools: node['bareos']['clients']['pools']
  )
end
template '/etc/bareos/bareos-dir.d/schedules.conf' do
  source 'schedules.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    client_schedules: node['bareos']['clients']['schedules']
  )
end
template '/etc/bareos/bareos-dir.d/storages.conf' do
  source 'storages.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    client_storages: node['bareos']['clients']['storages']
  )
end

# Allow a reload of the director daemon configs if called with tests up front
execute 'reload-dir' do
  command 'su - bareos -s /bin/sh -c "/usr/sbin/bareos-dir -t -c /etc/bareos/bareos-dir.conf" && echo reload | bconsole'
  action :nothing
  subscribes :run, 'template[/etc/bareos/bareos-dir.d/storages.conf]', :delayed
  subscribes :run, 'template[/etc/bareos/bareos-dir.d/schedules.conf]', :delayed
  subscribes :run, 'template[/etc/bareos/bareos-dir.d/pools.conf]', :delayed
  subscribes :run, 'template[/etc/bareos/bareos-dir.d/filesets.conf]', :delayed
  subscribes :run, 'template[/etc/bareos/bareos-dir.d/job_definitions.conf]', :delayed
  subscribes :run, 'template[/etc/bareos/bareos-dir.d/jobs.conf]', :delayed
  subscribes :run, 'template[/etc/bareos/bareos-dir.d/clients.conf]', :delayed
  subscribes :run, 'template[/etc/bareos/bareos-dir.conf]', :delayed
  notifies :restart, 'service[bareos-dir]', :delayed
end

# Enable and start the bareos-dir service
service 'bareos-dir' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
