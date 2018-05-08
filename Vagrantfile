# -*- mode: ruby -*-
# vi: set ft=ruby :

## Vagrant Settings ##

# Vagrant BOX
vm_box                = 'bento/centos-7.4'
# vm_box                = 'bento/centos-6.9'

# VAW default Vagrant BOX
# vm_box                = 'vaw/centos7-default'
# vm_box                = 'vaw/centos7-full'

vm_box_version        = '>= 0'
vm_ip                 = '192.168.46.49'
vm_hostname           = 'vaw.local'
vm_document_root      = '/var/www/html'

public_ip             = ''

vbguest_auto_update   = false

ansible_install_mode  = :default    # :default|:pip
ansible_version       = 'latest'    # only :pip required

provision_mode        = 'all'       # all|wordpress|box

## That's all, stop setting. ##

provision = <<-EOT
  if [ -e /etc/os-release ]; then
    MAJOR=$(awk '/VERSION_ID=/' /etc/os-release | sed 's/VERSION_ID=//' | sed 's/"//g' | sed -E 's/\.[0-9]{2}//g')
  elif [ -e /etc/redhat-release ]; then
    MAJOR=$(awk '{print $3}' /etc/redhat-release | sed -E 's/\.[0-9]+//g')
  fi
  echo $MAJOR > /etc/yum/vars/releasever

  if [ "$MAJOR" = "6" ]; then
    yum makecache fast
    yum -y install epel-release
  fi
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

  config.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
  config.vm.network :forwarded_port, guest: 3001, host: 3001, auto_correct: true

  config.vm.synced_folder '.', '/vagrant', :type => "virtualbox", :create => 'true'
  config.vm.synced_folder 'wordpress/', vm_document_root, :type => "virtualbox", :create => 'true', :mount_options => ['dmode=755', 'fmode=644']

  config.ssh.forward_agent = true

  if Vagrant.has_plugin?("vagrant-hostsupdater")
    config.hostsupdater.remove_on_suspend = true
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = vbguest_auto_update
  end

  config.vm.provider "virtualbox" do |vb|
    vb.customize [
      "modifyvm", :id,
      "--memory", "1536",
      '--natdnshostresolver1', 'on',
      '--natdnsproxy1', 'on',
      '--cableconnected1', "on",
      "--hwvirtex", "on",
      "--nestedpaging", "on",
      "--largepages", "on",
      "--ioapic", "on",
      "--pae", "on",
      "--paravirtprovider", "kvm",
    ]
  end

  config.vm.provision :shell, :inline => provision

  if provision_mode == 'wordpress' then
    ansible_tags = 'sync-dir'
  elsif provision_mode == 'box' then
    ansible_skip_tags = 'sync-dir'
  end

  config.vm.provision "ansible_local" do |ansible|
    ansible.install_mode = ansible_install_mode
    ansible.version = ansible_version
    ansible.inventory_path = 'hosts/local'
    ansible.playbook = 'site.yml'
    ansible.tags = ansible_tags
    ansible.verbose = 'v'
    ansible.skip_tags = ansible_skip_tags
    ansible.extra_vars = {
      HOSTNAME: vm_hostname,
      DOCUMENT_ROOT: vm_document_root
    }
  end

  if provision_mode == 'box' then
    config.vm.provision :shell, path: "command/centos-box.sh"
  end

  if Vagrant.has_plugin?("vagrant-serverspec")
    if provision_mode == 'wordpress' then
      config.vm.provision :serverspec do |spec|
        spec.pattern = "spec/sync-dir/*_spec.rb"
      end
    elsif provision_mode == 'box' then
      config.vm.provision :serverspec do |spec|
        spec.pattern = "spec/box/*_spec.rb"
      end
    else
      config.vm.provision :serverspec do |spec|
        spec.pattern = "spec/localhost/*_spec.rb"
      end
    end
  end

end
