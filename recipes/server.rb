#
# Cookbook Name:: bareos
# Recipe:: server
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#
node.set_unless['bareos']['dir_password'] = secure_password
#node.set_unless['bareos']['sd_password'] = secure_password
#node.set_unless['bareos']['fd_password'] = secure_password
node.set_unless['bareos']['mon_password'] = secure_password
node.save

# Installation des services BAREOS

package 'bareos-director' do
  action :install
end

package 'bareos-tools' do
  action :install
end

bareos_clients = search(:node, 'NOT role:backup-server')

template '/etc/bareos/bareos-dir.conf' do
  source 'bareos-dir.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    :db_driver => node['bareos']['dbdriver'],
    :db_name => node['bareos']['dbname'],
    :db_user => node['bareos']['dbuser'],
    :db_password => node['bareos']['dbpassword'],
    :bareos_clients => bareos_clients
  )

  notifies :reload, 'service[bareos-dir]', :immediately
end

service 'bareos-dir' do
  supports :status => true, :restart => true, :reload => false
  action [:enable, :start]
end
