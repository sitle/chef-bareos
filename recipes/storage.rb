# encoding: UTF-8
#
# Copyright (C) 2016 Leonard TAVAE
#
# Cookbook Name:: chef-bareos
# Recipe:: storage
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

# Include the OpenSSL cookbook library
# Setup Storage Daemon Random Passwords
::Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)
node.set_unless['bareos']['sd_password'] = random_password(length: 30, mode: :base64)
node.save unless Chef::Config[:solo]

# Install BAREOS Storage Daemon Packages
include_recipe 'chef-bareos::repo'
package 'bareos-storage' do
  action :install
end

# Find Storage Daemon(s) and Director(s)
storage_search_query = node['bareos']['storage']['storage_search_query']
dir_search_query = node['bareos']['director']['dir_search_query']
if Chef::Config.solo
  bareos_sd = node['bareos']['storage']['servers']
  bareos_dir = node['bareos']['director']['servers']
else
  bareos_sd = search(:node, storage_search_query)
  bareos_dir = search(:node, dir_search_query)
end

# Create the custom config directory and placeholder file
directory '/etc/bareos/bareos-sd.d' do
  owner 'root'
  group 'bareos'
  mode '0755'
  action :create
end

template '/etc/bareos/bareos-sd.d/sd_helper.conf' do
  source 'sd_helper.conf.erb'
  owner 'root'
  group 'bareos'
  mode '0644'
  variables(
    sd_help: node['bareos']['storage']['conf']['help']
  )
  sensitive true
  action :create
end

# SD Config
template '/etc/bareos/bareos-sd.conf' do
  source 'bareos-sd.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    bareos_sd: bareos_sd,
    bareos_dir: bareos_dir
  )
  sensitive true
  only_if { File.exist?('/etc/bareos/bareos-sd.d/sd_helper.conf') }
end

# Experimental Tape Autochanger Support
include_recipe 'chef-bareos::autochanger' if node['bareos']['storage']['autochanger_enabled']

# Test Config before restarting SD
execute 'restart-sd' do
  command 'bareos-sd -t -c /etc/bareos/bareos-sd.conf'
  action :nothing
  subscribes :run, 'template[/etc/bareos/bareos-sd.conf]', :immediately
  notifies :restart, 'service[bareos-sd]', :delayed
end

# Start and enable SD service
service 'bareos-sd' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
