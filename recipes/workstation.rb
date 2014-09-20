#
# Cookbook Name:: bareos
# Recipe:: server
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#

# Installation des services BAREOS

package 'bareos-bconsole' do
  action :install
end

template '/etc/bareos/bconsole.conf' do
  source 'bconsole.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
  variables(
    :dir_password => node['bareos']['dir_password'],
  )
end
