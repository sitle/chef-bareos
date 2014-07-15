#
# Cookbook Name:: bareos
# Recipe:: server
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#

# Installation des services BAREOS

package "bareos-director" do
    action :install
end

package "bareos-tools" do
    action :install
end

service "bareos-dir" do
    supports :status => true, :restart => true, :reload => false
    action [ :enable, :start ]
end

template '/etc/bareos/bareos-dir.conf' do
    source 'bareos-dir.conf.erb'
    mode 0640
    owner 'bareos'
    group 'bareos'
    variables(
                :dir_password => node["bareos"]["dir_password"]
    )
    notifies :reload, "service[bareos-dir]", :immediately 
end