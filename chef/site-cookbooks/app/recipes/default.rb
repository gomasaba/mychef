#
# Cookbook Name:: app
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "memcached" do
    action :install
end
service "memcached" do
  supports :status => true, :restart => true, :reload => true
  action :start
end

package "gd" do
    action :install
end

package "vim" do
    action :install
end

service 'iptables' do
  action [:disable, :stop]
end

package "git" do
    action :install
end