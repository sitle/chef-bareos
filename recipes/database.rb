# encoding: UTF-8
# Cookbook Name:: bareos
# Recipe:: database
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


package 'bareos-database-tools' do
  action :install
end

database = node['bareos']['database_type']

case database
when 'postgresql'
  include_recipe 'postgresql::server'

  package "bareos-database-#{database}" do
    action :install
  end

else
  if platform_family?('rhel')
    database_client_name = database.to_s
    database_server_name = "#{database}-server"
  else
    database_client_name = "#{database}-client"
    database_server_name = database.to_s
  end

  package database_client_name.to_s do
    action :install
  end

  package database_server_name.to_s do
    action :install
  end

  package "bareos-database-#{database}" do
    action :install
  end
end

if database == 'postgresql'

  user 'bareos' do
    shell '/bin/sh'
    action :modify
  end

  include_recipe 'database::postgresql'

  postgresql_connection_info = {
    :host => '127.0.0.1',
    :port => node['postgresql']['config']['port'],
    :username => 'postgres',
    :password => node['postgresql']['password']['postgres']
  }

  postgresql_database_user 'bareos' do
    connection postgresql_connection_info
    password node['bareos']['dbpassword']
    action :create
  end

  postgresql_database 'bareos' do
    connection postgresql_connection_info
    template 'template0'
    encoding 'SQL_ASCII'
    collation 'C'
    tablespace 'DEFAULT'
    connection_limit '-1'
    owner 'bareos'
    action :create
  end

  postgresql_database_user 'bareos' do
    connection postgresql_connection_info
    database_name 'bareos'
    privileges [:all]    
    action :grant
  end

  execute 'create_tables' do
    command 'su bareos -c "/usr/lib/bareos/scripts/make_bareos_tables" && touch /usr/lib/bareos/.dbtablescreated'
    creates '/usr/lib/bareos/.dbtablescreated'
    action :run
  end
end
