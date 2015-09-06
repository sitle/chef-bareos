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

# Setup Storage Daemon Random Passwords
node.set_unless['bareos']['sd_password'] = random_password(length: 30, mode: :base64)
node.save unless Chef::Config[:solo]

# Install BAREOS Storage Daemon Packages
package 'bareos-storage' do
  action :install
end

# if node['bareos']['storage']['tape'] == 'true'
# package  "bareos-storage-tape" do
#   action :install
#  end
# end

if Chef::Config[:solo]
  bareos_server = node['bareos']['server']
else
  bareos_server = search(:node, 'role:bareos_server')
end

template '/etc/bareos/bareos-sd.conf' do
  source 'bareos-sd.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    bareos_server: bareos_server
  )
  notifies :run, 'execute[restart-sd]', :delayed
end

directory '/etc/bareos/bareos-sd.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  notifies :run, 'execute[restart-sd]', :delayed
end

execute 'restart-sd' do
  command 'bareos-sd -t -c /etc/bareos/bareos-sd.conf'
  action :nothing
  notifies :restart, 'service[bareos-sd]', :immediately
end

service 'bareos-sd' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
