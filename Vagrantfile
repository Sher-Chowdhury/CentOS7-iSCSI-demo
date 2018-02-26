# -*- mode: ruby -*-
# vi: set ft=ruby :


# http://stackoverflow.com/questions/19492738/demand-a-vagrant-plugin-within-the-vagrantfile
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
required_plugins = %w( vagrant-hosts vagrant-share vagrant-vbox-snapshot vagrant-host-shell vagrant-triggers vagrant-reload )
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
  puts "Installing plugins: #{plugins_to_install.join(' ')}"
  if system "vagrant plugin install #{plugins_to_install.join(' ')}"
    exec "vagrant #{ARGV.join(' ')}"
  else
    abort "Installation of one or more plugins has failed. Aborting."
  end
end



Vagrant.configure(2) do |config|
  config.vm.define "iSCSI_target_server" do |iSCSI_target_server_config|
    iSCSI_target_server_config.vm.box = "bento/centos-7.4"
    iSCSI_target_server_config.vm.hostname = "iscsi-target.codingbee.net"

    file_to_disk = './tmp/large_disk.vdi'
    config.vm.customize ['createhd', '--filename', file_to_disk, '--size', 2 * 1024]
    config.vm.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]


    # https://www.vagrantup.com/docs/virtualbox/networking.html
    iSCSI_target_server_config.vm.network "private_network", ip: "192.168.14.100", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    iSCSI_target_server_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_iSCSI_target_server"
    end

    iSCSI_target_server_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    iSCSI_target_server_config.vm.provision "shell", path: "scripts/setup-iSCSI-target.sh", privileged: true
  end

  config.vm.define "iSCSI_initiator" do |iSCSI_initiator_config|
    iSCSI_initiator_config.vm.box = "bento/centos-7.4"
    iSCSI_initiator_config.vm.hostname = "iscsi-initiator.codingbee.net"
    iSCSI_initiator_config.vm.network "private_network", ip: "192.168.14.101", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    iSCSI_initiator_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_iSCSI_initiator"
    end

    iSCSI_initiator_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    iSCSI_initiator_config.vm.provision "shell", path: "", privileged: true
  end

  # this line relates to the vagrant-hosts plugin, https://github.com/oscar-stack/vagrant-hosts
  # it adds entry to the /etc/hosts file. 
  # this block is placed outside the define blocks so that it gts applied to all VMs that are defined in this vagrantfile. 
  config.vm.provision :hosts do |provisioner|
    provisioner.add_host '192.168.14.100', ['iscsi-target.codingbee.net']  
    provisioner.add_host '192.168.14.101', ['iscsi-initiator.codingbee.net']
  end


end
