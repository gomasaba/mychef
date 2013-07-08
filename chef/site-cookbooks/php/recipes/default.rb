#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{php php-devel php-mysql phpMyAdmin phpPgAdmin php-pgsql php-pdo php-xml php-mbstring php-gd php-pear php-pecl-memcached php-pecl-xdebug}.each do |pkg|
    package pkg do
        action :install
        notifies :restart, 'service[httpd]'
    end
end
execute "phpunit" do
    command "pear config-set auto_discover 1"
    action :run
    not_if "which phpunit"
end
execute "phpunit" do
    command "pear install pear.phpunit.de/PHPUnit"
    action :run
    not_if "which phpunit"
end

directory "/var/lib/php/session" do
    owner "apache"
    group "apache"
    mode 0777
    action :create
end


template "/etc/php.ini" do
  notifies :restart, 'service[httpd]'
end