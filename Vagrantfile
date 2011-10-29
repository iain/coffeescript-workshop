#!/usr/bin/env ruby
Vagrant::Config.run do |config|
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"
  config.vm.forward_port "http", 8080, 8080
  config.vm.provision :shell, :path => "install.sh"
end
