#
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
#

node.set_unless['bareos']['sd_password'] = secure_password
node.save unless Chef::Config[:solo]

# Installation du Storage daemon BAREOS

package 'bareos-storage' do
  action :install
end

# if node['bareos']['tape'] == 'true'
# package  "bareos-storage-tape" do
#   action :install
#  end
# end

if Chef::Config[:solo]
  bareos_clients = node['bareos']['clients']
else
  bareos_clients = search(:node, 'NOT role:backup-server')
end

template '/etc/bareos/bareos-sd.conf' do
  source 'bareos-sd.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    bareos_clients: bareos_clients
  )
  notifies :reload, 'service[bareos-dir]', :immediately
end

service 'bareos-sd' do
  supports status: true, restart: true, reload: false
  action [:enable, :start]
end
