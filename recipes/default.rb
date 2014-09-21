#
# Cookbook Name:: bareos
# Recipe:: default
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#

# Installation du dépôt BAREOS

if platform_family?('rhel')
  yum_repository node['bareos']['yum_repository'] do
    description node['bareos']['description']
    baseurl node['bareos']['baseurl']
    gpgkey node['bareos']['gpgkey']
    action :create
  end
else
  apt_repository 'bareos' do
    uri node['bareos']['baseurl']
    components ['/']
    key node['bareos']['gpgkey']
  end
end

include_recipe 'bareos::client'
