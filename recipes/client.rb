#
# Cookbook Name:: bareos
# Recipe:: client
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#
include_recipe "openssl::default"

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['bareos']['fd_password'] = secure_password
node.set_unless['bareos']['mon_password'] = secure_password

# Installation du File daemon BAREOS

package 'bareos-filedaemon' do
  action :install
end

#director = search(node, 'role:bareos-server')

template '/etc/bareos/bareos-fd.conf' do
  source 'bareos-fd.conf.erb'
  owner 'root'
  group 'bareos'
  mode '0640'
  notifies :reload, 'service[bareos-fd]', :immediately
end

service 'bareos-fd' do
  supports :status => true, :restart => true, :reload => false
  action [:enable, :start]
end
