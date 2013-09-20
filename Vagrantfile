# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "centos64"
    config.vm.hostname = "vb-centos64"
    config.vm.provider :virtualbox do |vb|
        vb.name = "centos64"
    end
    # config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :private_network, ip: "192.168.33.20"

    config.vm.synced_folder "C:\\projects", "/projects"
    config.vm.synced_folder "C:\\projects_others", "/projects_others"
    config.vm.provider :virtualbox do |vb|
        #vb.gui = true
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end

    VAGRANT_JSON = MultiJson.load(Pathname(__FILE__).dirname.join('chef/nodes', 'vagrant.json').read)
    config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path    = ["./chef/site-cookbooks", "./chef/cookbooks"]
        chef.roles_path        = "./chef/roles"
        chef.data_bags_path    = "./chef/data_bags"
        #chef.provisioning_path = "/tmp/vagrant-chef"

        chef.json = VAGRANT_JSON
        VAGRANT_JSON['run_list'].each do |recipe|
        chef.add_recipe(recipe)
        end if VAGRANT_JSON['run_list']

        Dir["#{Pathname(__FILE__).dirname.join('chef/roles')}/*.json"].each do |role|
            chef.add_role(role)
        end
    end

end
