#
# Cookbook Name:: bareos
# Recipe:: storage
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#
node.set_unless['bareos']['sd_password'] = secure_password
#node.set_unless['bareos']['mon_password'] = secure_password
node.save

# Installation du Storage daemon BAREOS

package 'bareos-storage' do
  action :install
end

if node['bareos']['tape'] == 'enable'
  package "bareos-storage-tape" do
    action :install
  end
end

bareos_clients = search(:node, 'NOT role:backup-server')

template '/etc/bareos/bareos-sd.conf' do
  source 'bareos-sd.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    :bareos_clients => bareos_clients
  )
  notifies :reload, 'service[bareos-dir]', :immediately
end

service 'bareos-sd' do
  supports :status => true, :restart => true, :reload => false
  action [:enable, :start]
end
