# -*- mode: ruby -*-
# vi: set ft=ruby :

ssh_public_key = "#{ENV['HOME']}/.ssh/id_ed25519.pub"

# These IPs are also used in the config for metallb: ./base/metallb/config.yaml 
cluster = {
  "control1" => { :ip => "192.168.33.16", :vagrant_primary => true},
  # "control2" => { :ip => "192.168.33.17" },
  # "control3" => { :ip => "192.168.33.18" },
  "worker1" => { :ip => "192.168.33.32",:memory=>4096},
  "worker2" => { :ip => "192.168.33.33",:memory=>4096},
#  "worker3" => { :ip => "192.168.33.34",:memory=>2048}
}

Vagrant.configure("2") do |config|

  config.vm.box = "debian/buster64"
  
  config.vm.synced_folder ".", "/vagrant",:nfs_version => 3

  cluster.each_with_index do |(hostname, info), index|
    config.vm.define hostname, vagrant_primary: info.fetch(:vagrant_primary,false) do |node|
      node.vm.hostname = hostname
      node.vm.network  :private_network, :type => "static", :ip => "#{info[:ip]}"
      node.vm.provider :libvirt do |libvirt|
        libvirt.memory = info.fetch(:memory, 2048)
        libvirt.cpus = info.fetch(:cpus, 2)
      end
      node.vm.provider "virtualbox" do |vbox|
        vbox.linked_clone = true
        vbox.name = hostname
        vbox.gui = false
        vbox.memory = info.fetch(:memory, 2048)
        vbox.cpus = info.fetch(:cpus, 2)
        vbox.customize ["modifyvm", :id, "--ioapic", "on"]   
      end
      node.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines(ssh_public_key).first.strip
        s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        SHELL
      end
      if index == cluster.length-1
        node.vm.provision :ansible do |ansible|
          ansible.limit = "all,localhost"
          ansible.config_file = "./ansible/ansible.cfg"
          ansible.playbook = "./ansible/main.yaml"
          ansible.groups = {
            "workers" => ["worker1","worker2"]
          }
        end
      end
    end
  end
end
