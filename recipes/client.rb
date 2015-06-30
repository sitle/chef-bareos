# encoding: UTF-8
# Cookbook Name:: bareos
# Recipe:: client
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
#

node.set_unless['bareos']['fd_password'] = random_password(length: 30, mode: :base64)
node.set_unless['bareos']['mon_password'] = random_password(length: 30, mode: :base64)
node.save unless Chef::Config[:solo]

# Installation du File daemon BAREOS

package 'bareos-filedaemon' do
  action :install
end

if Chef::Config[:solo]
  bareos_server = node['bareos']['server']
else
  bareos_server = search(:node, 'role:bareos_server')
end

template '/etc/bareos/bareos-fd.conf' do
  source 'bareos-fd.conf.erb'
  owner 'root'
  group 'bareos'
  mode '0640'
  variables(
    bareos_server: bareos_server
  )
  notifies :reload, 'service[bareos-fd]', :immediately
end

service 'bareos-fd' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
