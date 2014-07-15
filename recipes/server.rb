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

template '/etc/bareos/bareos-dir.conf' do
    source 'bareos-dir.conf.erb'
    mode 0640
    owner 'bareos'
    group 'bareos'
    variables(
                :dir_password => node["bareos"]["dir_password"],
                :sd_password => node["bareos"]["sd_password"],
                :fd_password => node["bareos"]["fd_password"],
                :db_driver => node["bareos"]["dbdriver"],
                :db_name => node["bareos"]["dbname"],
                :db_user => node["bareos"]["dbuser"],
                :db_password => node["bareos"]["dbpassword"],
                :mon_password => node["bareos"]["mon_password"]
    )
    notifies :reload, "service[bareos-dir]", :immediately 
end

service "bareos-dir" do
    supports :status => true, :restart => true, :reload => false
    action [ :enable, :start ]
end