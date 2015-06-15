# encoding: UTF-8
# Cookbook Name:: bareos
# Recipe:: default
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

include_recipe 'openssl::default'

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

if platform_family?('rhel')
  yum_repository node['bareos']['yum_repository'] do
    description node['bareos']['description']
    baseurl node['bareos']['baseurl']
    gpgkey node['bareos']['gpgkey']
    action :create
  end
else
  apt_repository 'bareos' do
    uri node['bareos']['baseurl']
    components ['/']
    key node['bareos']['gpgkey']
  end
end

include_recipe 'bareos::client'
