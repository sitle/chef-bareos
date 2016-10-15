# encoding: UTF-8
#
# Cookbook Name:: chef-bareos
# Recipe:: graphite_plugin
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

include_recipe 'chef-bareos::repo'

if platform_family?('rhel') && node['platform_version'].to_i == 6
  package ['python', 'python-bareos', 'python-requests', 'python-fedora-django']
else
  package ['python', 'python-bareos', 'python-requests', 'python-django']
end

directory node['bareos']['plugins']['graphite']['config_path']

template "#{node['bareos']['plugins']['graphite']['config_path']}/graphite-poller.conf" do
  owner 'bareos'
  group 'bareos'
  mode '0740'
  sensitive node['bareos']['plugins']['graphite']['sensitive_configs']
end

remote_file "#{node['bareos']['plugins']['graphite']['plugin_path']}/bareos-graphite-poller.py" do
  source node['bareos']['plugins']['graphite']['graphite_plugin_src_url']
  owner 'bareos'
  group 'bareos'
  mode '0740'
  use_last_modified true
  use_conditional_get true
  sensitive node['bareos']['plugins']['graphite']['sensitive_configs']
end

cron 'bareos_graphite_poller' do
  command node['bareos']['plugins']['graphite']['cron_command']
  mailto node['bareos']['plugins']['graphite']['mail_to']
  only_if { node['bareos']['plugins']['graphite']['cron_job'] }
end
