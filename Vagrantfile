# -*- mode: ruby -*-
# vi: set ft=ruby :

## Vagrant Settings ##

# Debian Long Term Support -  See https://wiki.debian.org/LTS
# vm_box                = 'debian/bookworm64'  # Debian 12.0
vm_box                = 'debian/bullseye64'    # Debian 11.0
# vm_box                = 'debian/buster64'    # Debian 10.0 # Deprecated ended 2024-06-30
# vm_box                = 'debian/stretch64'   # Debian 9.0 # Deprecated ended 2022-06-30 Note: Ansible version 2.2.x installed, so install via pip instead.
# vm_box                = 'debian/jessie64'    # Debian 8.0 # Deprecated ended 2020-06-30
# Ubuntu release cycle - See https://ubuntu.com/about/release-cycle
# vm_box                = 'ubuntu/jammy64'     # Ubuntu 22.04
# vm_box                = 'ubuntu/focal64'     # Ubuntu 20.04
# vm_box                = 'ubuntu/bionic64'    # Ubuntu 18.04
# vm_box                = 'ubuntu/xenial64'    # Ubuntu 16.04
# vm_box                = 'ubuntu/trusty64'    # Ubuntu 14.04
# vm_box                = 'almalinux/9'
# vm_box                = 'almalinux/8'
# vm_box                = 'rockylinux/9'
# vm_box                = 'rockylinux/8'
# vm_box                = 'centos/8' # Deprecated ended 2021-12-31
# vm_box                = 'centos/7' # Deprecated ended 2024-06-30
# vm_box                = 'centos/6' # Deprecated ended 2020-11-30

vm_box_version        = '>= 0'
vm_ip                 = '192.168.46.49'
vm_hostname           = 'vaw.local'
vm_document_root      = '/var/www/html'

public_ip             = ''

forwarded_port        = [
  3000,
  3001,
  1025,
  8025
]

vbguest_auto_update   = true
synced_folder_type    = 'virtualbox' # virtualbox|nfs|rsync|smb

backup_database       = false

ansible_install       = true
ansible_install_mode  = :default    # :default|:pip
ansible_version       = 'latest'    # requires :pip in ansible_install_mode

provision_mode        = 'all'       # all|wordpress|box

vagrant_plugins       = [
	'vagrant-hostsupdater',
	'vagrant-vbguest',
	'vagrant-serverspec'
]

## That's all, stop setting. ##

provision = <<-EOT
  set -e
  if [ -e /etc/os-release ]; then
    DISTR=$(awk '/PRETTY_NAME=/' /etc/os-release | sed 's/PRETTY_NAME=//' | sed 's/"//g' | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
    if [ -e /etc/redhat-release ]; then
      VERSION=$(awk '{print $4}' /etc/redhat-release)
    elif [ "$DISTR" = "debian" ] && [ -e /etc/debian_version ]; then
      VERSION=$(awk '{print $1}' /etc/debian_version)
    else
      VERSION=$(awk '/VERSION_ID=/' /etc/os-release | sed 's/VERSION_ID=//' | sed 's/"//g')
    fi
    MAJOR=$(awk '/VERSION_ID=/' /etc/os-release | sed 's/VERSION_ID=//' | sed 's/"//g' | sed -E 's/\.[0-9]{2}//g')
    if [ -e /etc/lsb-release ]; then
      RELEASE=$(awk '/DISTRIB_CODENAME=/' /etc/lsb-release | sed 's/DISTRIB_CODENAME=//' | sed 's/"//g' | tr '[:upper:]' '[:lower:]')
    else
      RELEASE=$(awk '/PRETTY_NAME=/' /etc/os-release | sed 's/"//g' | awk '{print $4}' | sed 's/[()]//g' | tr '[:upper:]' '[:lower:]')
    fi
  elif [ -e /etc/redhat-release ]; then
    DISTR=$(awk '{print $1}' /etc/redhat-release | tr '[:upper:]' '[:lower:]')
    VERSION=$(awk '{print $3}' /etc/redhat-release)
    MAJOR=$(awk '{print $3}' /etc/redhat-release | sed -E 's/\.[0-9]+//g')
    RELEASE=$(awk '{print $4}' /etc/redhat-release | sed 's/[()]//g' | tr '[:upper:]' '[:lower:]')
  fi
  ARCH=$(uname -m)
  BITS=$(uname -m | sed 's/x86_//;s/amd//;s/i[3-6]86/32/')

  echo '[OS Info]'
  echo 'DISTRIBUTE:' $DISTR
  echo 'ARCHITECTURE:' $ARCH
  echo 'BITS:' $BITS
  echo 'RELEASE:' $RELEASE
  echo 'VERSION:' $VERSION
  echo 'MAJOR:' $MAJOR

  if [ "$DISTR" = "centos" ] && [ "$MAJOR" = "6" ]; then
    yum makecache fast
    yum -y install epel-release
  fi

  if [ "$DISTR" = "debian" ]; then
    apt-get -y install dirmngr
    echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' > /etc/apt/sources.list.d/ansible.list
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 93C4A3FD7BB9C367

    if [ "$RELEASE" = "jessie" ]; then
      echo 'deb http://ftp.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/backports.list
      apt-get update
    fi
  fi
EOT

vagrant_plugins.each{|plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
}

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

  forwarded_port.each{|port|
    config.vm.network :forwarded_port, guest: port, host: port, auto_correct: true
  }

  config.vm.synced_folder '.', '/vagrant', :type => synced_folder_type, :create => 'true'
  config.vm.synced_folder 'wordpress/', vm_document_root, :type => synced_folder_type, :create => 'true'

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
      "--memory", "2048",
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
    ansible.install = ansible_install
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

  if backup_database
    config.trigger.before [:destroy, :halt] do |trigger|
      trigger.name = "Backup database"
      trigger.warn = "Dumping database"
      trigger.run_remote = { inline: "sudo -u vagrant -i -- /vagrant/command/db_backup.sh" }
    end
  end

end
