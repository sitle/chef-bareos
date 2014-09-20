#
# Cookbook Name:: bareos
# Recipe:: database
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#

# Installation de la base de donnée BAREOS

package 'bareos-database-tools' do
  action :install
end

database = node['bareos']['database_type']

if platform_family?('rhel')
  database_client_name = "#{database}"
  database_server_name = "#{database}-server"
else
  database_client_name = "#{database}-client"
  database_server_name = "#{database}"
end

package "#{database_client_name}" do
  action :install
end

package "#{database_server_name}" do
  action :install
end

package "bareos-database-#{database}" do
  action :install
end

if database == 'postgresql'
  # Initialisation de la base de donnée postgres
  execute 'initdb' do
    command 'su postgres -c "initdb -D /var/lib/pgsql/data"'
    action :run
    not_if { ::File.exists?('/var/lib/pgsql/data/postgresql.conf') }
    not_if { ::File.exist?('/etc/postgresql/9.1/main/postgresql.conf') }
  end

  service 'postgresql' do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
  end

  execute 'create_database' do
    command 'su postgres -c "/usr/lib/bareos/scripts/create_postgresql_database"'
    action :run
  end

  execute 'create_tables' do
    command 'su postgres -c "/usr/lib/bareos/scripts/make_postgresql_tables"'
    creates '/tmp/something'
    action :run
  end

  execute 'grant_privileges' do
    command 'su postgres -c "/usr/lib/bareos/scripts/grant_postgresql_privileges"'
    creates '/tmp/something'
    action :run
  end
end
