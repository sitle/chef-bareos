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

if database == 'postgresql'
  execute 'initdb' do
    command 'su postgres -c "initdb -D /var/lib/pgsql/data"'
    action :run
    not_if { ::File.exist?('/var/lib/pgsql/data/postgresql.conf') }
    not_if { ::File.exist?('/etc/postgresql/9.1/main/postgresql.conf') }
  end

  service 'postgresql' do
    supports status: true, restart: true, reload: true
    action [:enable, :start]
  end

  execute 'create_database' do
    command 'su postgres -c "/usr/lib/bareos/scripts/create_bareos_database" && touch /usr/lib/bareos/.dbcreated'
    creates '/usr/lib/bareos/.dbcreated'
    action :run
  end

  execute 'create_tables' do
    command 'su postgres -c "/usr/lib/bareos/scripts/make_bareos_tables" && touch /usr/lib/bareos/.dbtablescreated'
    creates '/usr/lib/bareos/.dbtablescreated'
    action :run
  end

  execute 'grant_privileges' do
    command 'su postgres -c "/usr/lib/bareos/scripts/grant_bareos_privileges" && touch /usr/lib/bareos/.dbprivgranted'
    creates '/usr/lib/bareos/.dbprivgranted'
    action :run
  end
end
