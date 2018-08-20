# -*- mode: ruby -*-
# vi: set ft=ruby :


# https://github.com/hashicorp/vagrant/issues/1874#issuecomment-165904024
# not using 'vagrant-vbguest' vagrant plugin because now using bento images which has vbguestadditions preinstalled.
def ensure_plugins(plugins)
  logger = Vagrant::UI::Colored.new
  result = false
  plugins.each do |p|
    pm = Vagrant::Plugin::Manager.new(
      Vagrant::Plugin::Manager.user_plugins_file
    )
    plugin_hash = pm.installed_plugins
    next if plugin_hash.has_key?(p)
    result = true
    logger.warn("Installing plugin #{p}")
    pm.install_plugin(p)
  end
  if result
    logger.warn('Re-run vagrant up now that plugins are installed')
    exit
  end
end

required_plugins = ['vagrant-hosts', 'vagrant-share', 'vagrant-vbox-snapshot', 'vagrant-host-shell', 'vagrant-reload']
ensure_plugins required_plugins



Vagrant.configure(2) do |config|
  config.vm.define "iSCSI_target_server" do |iSCSI_target_server_config|
    iSCSI_target_server_config.vm.box = "bento/centos-7.5"
    iSCSI_target_server_config.vm.hostname = "target.cb.net"



    # https://www.vagrantup.com/docs/virtualbox/networking.html
    iSCSI_target_server_config.vm.network "private_network", ip: "192.168.14.100", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    iSCSI_target_server_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.name = "centos7_iSCSI_target_server"
      file_to_disk = './tmp/large_disk.vdi'
      vb.customize ['createhd', '--filename', file_to_disk, '--size', 2 * 1024]
      # https://github.com/kusnier/vagrant-persistent-storage/issues/33
      # vb.customize ['storageattach', :id, '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
      # for bento use following line:
      vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
    end

    iSCSI_target_server_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    iSCSI_target_server_config.vm.provision "shell", path: "scripts/setup-iSCSI-target.sh", privileged: true

  end

  config.vm.define "iSCSI_initiator" do |iSCSI_initiator_config|
    #iSCSI_initiator_config.vm.box = "centos/7"
    iSCSI_initiator_config.vm.box = "bento/centos-7.5"
    iSCSI_initiator_config.vm.hostname = "initiator.cb.net"
    iSCSI_initiator_config.vm.network "private_network", ip: "192.168.14.101", :netmask => "255.255.255.0", virtualbox__intnet: "intnet1"

    iSCSI_initiator_config.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
      vb.cpus = 2
      vb.name = "centos7_iSCSI_initiator"
    end

    iSCSI_initiator_config.vm.provision "shell", path: "scripts/install-rpms.sh", privileged: true
    iSCSI_initiator_config.vm.provision "shell", path: "scripts/setup-iSCSI-initiator.sh", privileged: true
  end

end
