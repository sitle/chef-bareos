# encoding: UTF-8
# Cookbook Name:: bareos
# Recipe:: storage
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

# Include the OpenSSL library by itself so it isn't dependant on the client recipe
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

# Include the repo recipe by default here, should be ok under most circumstances
include_recipe 'chef-bareos::repo'

# Setup Storage Daemon Random Passwords
node.set_unless['bareos']['sd_password'] = random_password(length: 30, mode: :base64)
node.save unless Chef::Config[:solo]

# Install BAREOS Storage Daemon Packages
package 'bareos-storage' do
  action :install
end

# Need more work on any Tape Integration
# if node['bareos']['storage']['tape'] == 'true'
# package  "bareos-storage-tape" do
#   action :install
#  end
# end

# Define both the bareos-sd and bareos-dir lists based on run_list searches
if Chef::Config[:solo]
  bareos_sd = node['bareos']['storage']['servers']
  bareos_dir = node['bareos']['director']['servers']
else
  bareos_sd = search(:node, node['bareos']['storage']['storage_search_query'])
  bareos_dir = search(:node, node['bareos']['director']['dir_search_query'])
end

# Setup the bareos-sd config
template '/etc/bareos/bareos-sd.conf' do
  source 'bareos-sd.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    bareos_sd: bareos_sd,
    bareos_dir: bareos_dir
  )
  notifies :run, 'execute[restart-sd]', :delayed
end

# Create the custom config directory
directory '/etc/bareos/bareos-sd.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :run, 'execute[restart-sd]', :delayed
end

# If called restart the bareos-sd confg(s) with a test first
execute 'restart-sd' do
  command 'bareos-sd -t -c /etc/bareos/bareos-sd.conf'
  action :nothing
  notifies :restart, 'service[bareos-sd]', :immediately
end

# Start and enable the bareos-sd service and run if called elsewhere
service 'bareos-sd' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
