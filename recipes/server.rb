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
#

node.set_unless['bareos']['dir_password'] = secure_password
node.set_unless['bareos']['mon_password'] = secure_password
node.save unless Chef::Config[:solo]

# Installation des services BAREOS

package 'bareos-director' do
  action :install
end

package 'bareos-tools' do
  action :install
end

if Chef::Config[:solo]
  bareos_clients = node['bareos']['clients']
else
  bareos_clients = search(:node, 'roles:bareos_base')
end

template '/etc/bareos/bareos-dir.conf' do
  source 'bareos-dir.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    db_driver: node['bareos']['dbdriver'],
    db_name: node['bareos']['dbname'],
    db_user: node['bareos']['dbuser'],
    db_password: node['bareos']['dbpassword'],
    bareos_clients: bareos_clients
  )

  notifies :reload, 'service[bareos-dir]', :immediately
end

service 'bareos-dir' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
