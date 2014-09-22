#
# Cookbook Name:: bareos
# Recipe:: server
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#
#node.set_unless['bareos']['dir_password'] = secure_password
#node.save

# Installation des services BAREOS

package 'bareos-bconsole' do
  action :install
end

template '/etc/bareos/bconsole.conf' do
  source 'bconsole.conf.erb'
  mode 0640
  owner 'bareos'
  group 'bareos'
end
