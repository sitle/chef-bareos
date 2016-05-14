# encoding: UTF-8
#
# Copyright (C) 2016 Leonard TAVAE
#
# Cookbook Name:: chef-bareos
# Recipe:: database
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

# Define the type of database desired, mysql still needs some cookbook work
database = node['bareos']['database']['database_type']

# Install the BAREOS database packages
include_recipe 'chef-bareos::repo'
package 'bareos-database-tools'
package "bareos-database-#{database}"

# Determine DB resources to install (psql/mysql)
case database
when 'postgresql'
  include_recipe 'postgresql::server'
else
  if platform_family?('rhel')
    database_client_name = database.to_s
    database_server_name = "#{database}-server"
  else
    database_client_name = "#{database}-client"
    database_server_name = database.to_s
  end
  package database_client_name.to_s
  package database_server_name.to_s
end

# Need to add some mysql logic here to do the database setup for bareos, psql only right now, mysql is manual
case database
when 'postgresql'
  execute 'create_database' do
    command 'su postgres -c /usr/lib/bareos/scripts/create_bareos_database && touch /usr/lib/bareos/.dbcreated'
    creates '/usr/lib/bareos/.dbcreated'
    action :run
  end
  execute 'create_tables' do
    command 'su postgres -s /bin/bash -c /usr/lib/bareos/scripts/make_bareos_tables && touch /usr/lib/bareos/.dbtablescreated'
    creates '/usr/lib/bareos/.dbtablescreated'
    action :run
  end
  execute 'grant_privileges' do
    command 'su postgres -s /bin/bash -c /usr/lib/bareos/scripts/grant_bareos_privileges && touch /usr/lib/bareos/.dbprivgranted'
    creates '/usr/lib/bareos/.dbprivgranted'
    action :run
  end
end
