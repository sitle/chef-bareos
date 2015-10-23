# encoding: UTF-8
# Cookbook Name:: bareos
# Recipe:: workstation
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

# Repo recipe is needed to install, so include by default, ok in most cases
include_recipe 'chef-bareos::repo'

# Install bconsole from repo
package 'bareos-bconsole' do
  action :install
end

# Define the list of bareos directors
if Chef::Config[:solo]
  bareos_dir = node['bareos']['director']['servers']
else
  bareos_dir = search(:node, "#{node['bareos']['director']['dir_search_query']}")
end

# Setup the bconsole config, pushes out list of bareos-dirs and if solo mode
template '/etc/bareos/bconsole.conf' do
  source 'bconsole.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  if Chef::Config[:solo]
    variables(
      bareos_dir: bareos_dir,
      solo_mode: Chef::Config[:solo] 
    )
  else
    variables(
      bareos_dir: bareos_dir
    )
  end
end
