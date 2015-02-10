# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "parallels/ubuntu-14.04"

  config.vm.provider "parallels" do |v|
  	v.name = "vagrant-apache"
  	v.update_guest_tools = true
  	v.memory = 512
  	v.cpus = 1
  end


  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
	config.vm.network :private_network, ip: "192.168.3.10"
	config.vm.hostname = "www.wp.dev"
	config.hostsupdater.aliases = ["www.wp.dev"]

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
	config.vm.provision :shell, path: "bootstrap.sh"
end
