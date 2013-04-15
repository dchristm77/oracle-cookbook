# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "dbBase"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  config.vm.hostname = "devdbbox"
  config.vm.network :private_network, ip: "192.168.50.4"

  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--name", "dev_env_11g", "--memory", "2048"]
  end

  # Set the timezone to PST/PDT as appropriate
  config.vm.provision :shell, :inline => "sudo ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime"

  config.vm.provision :chef_solo do |chef|
     chef.cookbooks_path = ["cookbooks","local_cookbooks"]
     chef.roles_path = "roles"
     chef.add_role("sysAdmin")
     chef.add_role("dev_database")
     chef.log_level = :debug
  
     chef.json = {
         :yum => {
             :proxy => "http://connsvr.nike.com:8080"
         }
     }
  end

end
