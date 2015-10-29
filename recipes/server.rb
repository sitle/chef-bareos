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

# Create a blank placeholder for d directory
execute 'director_conf_holder' do
  command 'touch /etc/bareos/bareos-dir.d/.conf'
  creates '/etc/bareos/bareos-dir.d/.conf'
  action :run
end

# Create the base config for the Bareos Director
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

# Create clients config based on sets of hashes, see attributes file for example
if Chef::Config[:solo]
  bareos_clients = node['bareos']['clients']['client_list']
else
  bareos_clients = search(:node, node['bareos']['clients']['client_search_query'])
end

template '/etc/bareos/bareos-dir.d/clients.conf' do
  source 'clients.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    bareos_client: bareos_clients,
    clients: bareos_clients
  )
  notifies :run, 'execute[reload-dir]', :delayed
end

# Create jobs config based on sets of hashes, see attributes file for example
template '/etc/bareos/bareos-dir.d/jobs.conf' do
  source 'jobs.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    bareos_client: bareos_clients,
    client_jobs: node['bareos']['clients']['jobs']
  )
  notifies :run, 'execute[reload-dir]', :delayed
end

# Create job definitions config based on sets of hashes, see attributes file for example
template '/etc/bareos/bareos-dir.d/job_definitions.conf' do
  source 'job_definitions.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    bareos_client: bareos_clients,
    job_definitions: node['bareos']['clients']['job_definitions']
  )
  notifies :run, 'execute[reload-dir]', :delayed
end

# Create filesets config based on sets of hashes, see attributes file for example
template '/etc/bareos/bareos-dir.d/filesets.conf' do
  source 'filesets.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    bareos_client: bareos_clients,
    fileset_options: node['baroes']['clients']['filesets']['options'],
    fileset_include_files: node['bareos']['clients']['filesets']['include'],
    fileset_exclude_files: node['bareos']['clients']['filesets']['exclude']
  )
  notifies :run, 'execute[reload-dir]', :delayed
end

# Create pools config based on sets of hashes, see attributes file for example
template '/etc/bareos/bareos-dir.d/pools.conf' do
  source 'pools.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    bareos_client: bareos_clients,
    client_pools: node['bareos']['clients']['pools']
  )
  notifies :run, 'execute[reload-dir]', :delayed
end

# Create schedules config based on sets of hashes, see attributes file for example
template '/etc/bareos/bareos-dir.d/schedules.conf' do
  source 'schedules.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    bareos_client: bareos_clients,
    client_schedules: node['bareos']['clients']['schedules']
  )
  notifies :run, 'execute[reload-dir]', :delayed
end

# Create storages config based on sets of hashes, see attributes file for example
template '/etc/bareos/bareos-dir.d/storages.conf' do
  source 'storages.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    director_storages: node['bareos']['director']['storages']
  )
  notifies :run, 'execute[reload-dir]', :delayed
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
