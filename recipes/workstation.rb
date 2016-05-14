# encoding: UTF-8
#
# Copyright (C) 2016 Leonard TAVAE
#
# Cookbook Name:: chef-bareos
# Recipe:: workstation
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

# Install bconsole from repo
include_recipe 'chef-bareos::repo'
package 'bareos-bconsole' do
  action :install
end

# Find director(s)
dir_search_query = node['bareos']['director']['dir_search_query']
bareos_dir = if Chef::Config[:solo]
               node['bareos']['director']['servers']
             else
               search(:node, dir_search_query)
             end

# bconsole config
template '/etc/bareos/bconsole.conf' do
  source 'bconsole.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    bareos_dir: bareos_dir
  )
  sensitive true
end
