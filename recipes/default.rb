#
# Cookbook Name:: bareos
# Recipe:: default
#
# Copyright 2014, DSI
#
# All rights reserved - Do Not Redistribute
#

# Installation du dépôt BAREOS

if platform_family?("rhel")
    yum_repository node["bareos"]["yum_repository"] do
        description node["bareos"]["description"]
        baseurl node["bareos"]["baseurl"]
        gpgkey node["bareos"]["gpgkey"]
        action :create
    end
else
    apt_repository "bareos" do
        uri "http://download.bareos.org/bareos/release/latest/xUbuntu_12.04/"
        components ['/']
        key "http://download.bareos.org/bareos/release/latest/xUbuntu_12.04/Release.key"
    end
end

include_recipe 'bareos::client'