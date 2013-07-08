#
# Cookbook Name:: user
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user "www" do
    comment "www"
    uid 502
    gid "www-data"
    home "/home/www"
    password "www"
end


group "www-data" do
  action :create
  members "www"
  append true
end

