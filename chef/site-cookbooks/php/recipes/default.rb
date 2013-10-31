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
template "/etc/php.d/xdebug.ini" do
    source "xdebug.ini.erb"
    notifies :restart, 'service[httpd]'
end

execute "composer" do
    command "curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin;mv usr/local/bin/composer.phar /usr/local/bin/composer"
    action :run
    not_if "which composer"
end


execute "phpunit" do
    command "pear config-set auto_discover 1 && pear install pear.phpunit.de/PHPUnit"
    action :run
    not_if "which phpunit"
end

#
# pear channel install
#
execute "pear-channel-phpdoc" do
    command "pear channel-discover pear.phpdoc.org"
    action :run
    not_if "pear list-channels | grep pear.phpdoc.org"
end
execute "pear-channel-phing" do
    command "pear channel-discover pear.phing.info"
    action :run
    not_if "pear list-channels | grep pear.phing.info"
end

execute "pear-channel-phpmd" do
    command "pear channel-discover pear.phpmd.org"
    action :run
    not_if "pear list-channels | grep pear.phpmd.org"
end

execute "pear-channel-phpcs" do
    command "pear channel-discover pear.cakephp.org"
    action :run
    not_if "pear list-channels | grep pear.cakephp.org"
end
#
# pear install
#
execute "pear-phpdoc" do
    command "pear install phpdoc/phpDocumentor"
    action :run
    not_if "which phpdoc"
end

execute "pear-phing" do
    command "pear install phing/phing"
    action :run
    not_if "which phing"
end

execute "pear-phpmd" do
    command "pear install --alldeps phpmd/PHP_PMD"
    action :run
    not_if "which phpmd"
end

execute "pear-phpcs" do
    command "pear install PHP_CodeSniffer && pear install cakephp/CakePHP_CodeSniffer"
    action :run
    not_if "which phpcs"
end

execute "phpcpd" do
    command "pear install phpunit/phpcpd"
    action :run
    not_if "which phpcpd"
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