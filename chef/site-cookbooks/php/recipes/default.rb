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
    command "pear config-set auto_discover 1 && pear install pear.phpunit.de/PHPUnit"
    action :run
    not_if "which phpunit"
end

execute "phpdoc" do
    command "pear channel-discover pear.phpdoc.org && pear install phpdoc/phpDocumentor"
    action :run
    not_if "which phpdoc"
end

execute "phing" do
    command "pear channel-discover pear.phing.info && pear install phing/phing"
    action :run
    not_if "which phing"
end
execute "phpmd" do
    command "pear channel-discover pear.phpmd.org && pear install --alldeps phpmd/PHP_PMD"
    action :run
    not_if "which phpmd"
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