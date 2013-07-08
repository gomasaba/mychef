#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
%w{httpd httpd-devel mod_ssl}.each do |pkg|
    package pkg do
        action :install
    end
end

service "httpd" do
  supports :status => true, :restart => true, :reload => true
end

template "/etc/httpd/conf/httpd.conf" do
  notifies :restart, 'service[httpd]'
end

template "/etc/httpd/conf.d/phpMyAdmin.conf" do
  notifies :restart, 'service[httpd]'
end

template "/etc/httpd/conf.d/phpPgAdmin.conf" do
  notifies :restart, 'service[httpd]'
end
