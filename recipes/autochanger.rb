# encoding: UTF-8
#
# Copyright (C) 2016 Leonard TAVAE
#
# Cookbook Name:: chef-bareos
# Recipe:: autochanger
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

# Experimental Tape Autochanger Support
package 'bareos-storage-tape'

execute 'mtx-changer' do
  command '/usr/bin/bareos/scripts/mtx-changer'
  creates '/etc/bareos/mtx-changer.conf'
  action :run
end

template '/etc/bareos/bareos-sd.d/device-tape-with-autoloader.conf' do
  source 'device-tape-with-autoloader.conf.erb'
  owner 'bareos'
  group 'bareos'
  mode '0640'
  variables(
    autochangers: node['bareos']['storage']['autochangers'],
    devices: node['bareos']['storage']['devices']
  )
  only_if { File.exist?('/etc/bareos/mtx-changer.conf') }
  notifies :restart, 'service[bareos-sd]', :delayed
  action :create
end
