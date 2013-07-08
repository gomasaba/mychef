#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
yum_key "RPM-GPG-KEY-jenkins" do
    url "http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key"
    action :add
end

remote_file "/etc/yum.repos.d/jenkins.repo" do
    source "http://pkg.jenkins-ci.org/redhat/jenkins.repo"
    mode 0644
    action :create_if_missing
end

yum_package "jenkins" do
    action :install
end

service "jenkins" do
    supports :restart => true, :reload => true
    action [:enable,:start]
end

execute "cli" do
    cwd "/root/"
    command "wget -O jenkins-cli.jar http://localhost:8080/jnlpJars/jenkins-cli.jar ;chmod 777 jenkins-cli.jar"
    action :run
    not_if { File.exists?("/jenkins-cli.jar") }
    notifies :start, 'service[jenkins]', :immediately
end

directory "/var/lib/jenkins/updates/" do
    owner "jenkins"
    group "jenkins"
    action :create
end

execute "update jenkins update center" do
    command "wget http://updates.jenkins-ci.org/update-center.json -qO- | sed '1d;$d'  > /var/lib/jenkins/updates/default.json"
    user "jenkins"
    group "jenkins"
    creates "/var/lib/jenkins/updates/default.json"
end


%w{git php checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit}.each do |plugin|
    execute "cli-plugin" do
        cwd "/root/"
        command "java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin #{plugin}"
        action :run
        notifies :run, 'execute[cli]', :immediately
        not_if { File.exists?("/var/lib/jenkins/plugins/#{plugin}.jpi") }
    end
end


execute "jenkins-restart" do
    cwd "/root/"
    command "java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart"
    action :run
end
