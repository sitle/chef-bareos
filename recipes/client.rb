#
# Cookbook Name:: bareos
# Recipe:: client
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#

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
  variables(
    :fd_password => node['bareos']['fd_password'],
    :mon_password => node['bareos']['mon_password']
  )
  notifies :reload, 'service[bareos-fd]', :immediately
end

service 'bareos-fd' do
  supports :status => true, :restart => true, :reload => false
  action [:enable, :start]
end
