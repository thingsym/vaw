# -*- mode: ruby -*-
# vi: set ft=ruby :

## Vagrant Settings ##

vm_box                = 'vaw/centos6-default'
# vm_box                = 'vaw/centos6-full'
vm_box_version        = '>= 0'
vm_ip                 = '192.168.46.49'
vm_hostname           = 'vaw.local'
vm_document_root      = '/var/www/html'

public_ip             = ''

vbguest_auto_update = false

## That's all, stop setting. ##

provision = <<-EOT
  VERSION=$(awk '{print $3}' /etc/*-release)
  if [[ $VERSION =~ ^release ]]; then
    VERSION=$(awk '{print $4}' /etc/*-release)
  fi

  if [[ $VERSION =~ ^6 ]]; then
    echo '6' > /etc/yum/vars/releasever
  elif [[ $VERSION =~ ^7 ]]; then
    echo '7' > /etc/yum/vars/releasever
  fi

  yum -y install epel-release
EOT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = vm_box
  config.vm.box_version = vm_box_version

  config.vm.network :private_network, ip: vm_ip
  config.vm.hostname = vm_hostname

  if public_ip != ''
    config.vm.network :public_network, ip: public_ip
  end

  config.vm.synced_folder 'wordpress/', vm_document_root, :create => 'true'

  config.ssh.forward_agent = true

  if Vagrant.has_plugin?("vagrant-hostsupdater")
    config.hostsupdater.remove_on_suspend = true
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = vbguest_auto_update
  end

  config.vm.provider "virtualbox" do |vb|
    # vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize [
      "modifyvm", :id,
      "--memory", "1536",
      '--natdnshostresolver1', 'on',
      '--natdnsproxy1', 'on',
    ]
  end

  config.vm.provision :shell, :inline => provision

  config.vm.provision "ansible_local" do |ansible|
    ansible.version = 'latest'
    ansible.inventory_path = 'hosts/local'
    ansible.playbook = 'site.yml'
    ansible.verbose = 'v'
    ansible.extra_vars = {
      HOSTNAME: vm_hostname,
      DOCUMENT_ROOT: vm_document_root
    }
  end

  if File.exist?("Rakefile")
    if Vagrant.has_plugin?("vagrant-serverspec")
      config.vm.provision :serverspec do |spec|
        spec.pattern = "spec/localhost/*_spec.rb"
      end
    end
  end

end
