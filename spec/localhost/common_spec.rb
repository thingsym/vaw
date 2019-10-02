require 'spec_helper'
require 'shellwords'

# require "pp"
# pp property

describe user('root') do
  it { should exist }
end

describe user('vagrant') do
  it { should exist }
end

describe package('libselinux-python') do
  it { should be_installed }
end

describe selinux do
  it { should_not be_enforcing }
end

describe service('iptables') do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe package('chrony'), :if => os[:release] == '7' do
  it { should be_installed }
end

describe service('chronyd'), :if => os[:release] == '7' do
  it { should be_enabled }
  it { should be_running }
end

describe package('ntp'), :if => os[:release] == '6' do
  it { should be_installed }
end

describe service('ntpd'), :if => os[:release] == '6' do
  it { should be_enabled }
  it { should be_running }
end

describe yumrepo('epel') do
  it { should exist }
end

describe yumrepo('ius') do
  it { should exist }
end

describe command('ansible --version') do
  its(:exit_status) { should eq 0 }
end

describe file('/home/vagrant/.bashrc_vaw') do
  it { should be_file }
end

describe file('/home/vagrant/.bashrc_vaw') do
  its(:content) { should match /export PATH=\/usr\/local\/bin:\/usr\/bin:\/bin:\/usr\/sbin:\/sbin:\/usr\/local\/sbin:\$PATH/ }
end

describe file('/home/vagrant/.bashrc'), :if => os[:family] == 'redhat' do
  its(:content) { should match /if \[ \-f ~\/\.bashrc_vaw \]; then\n        \. ~\/\.bashrc_vaw\nfi/ }
end

describe 'Linux kernel parameters' do
  context linux_kernel_parameter('net.core.somaxconn') do
    its(:value) { should eq 2048 }
  end
  context linux_kernel_parameter('net.ipv4.tcp_max_syn_backlog') do
    its(:value) { should be 2048 }
  end
  context linux_kernel_parameter('net.core.netdev_max_backlog') do
    its(:value) { should be 4096 }
  end

  context linux_kernel_parameter('net.ipv4.ip_local_port_range') do
    its(:value) { should match /1024\t65535/ }
  end
  context linux_kernel_parameter('net.ipv4.tcp_tw_reuse') do
    its(:value) { should eq 1 }
  end
  context linux_kernel_parameter('net.ipv4.tcp_fin_timeout') do
    its(:value) { should eq 10 }
  end
  context linux_kernel_parameter('net.ipv4.tcp_keepalive_time') do
    its(:value) { should eq 10 }
  end
  context linux_kernel_parameter('net.ipv4.tcp_keepalive_probes') do
    its(:value) { should eq 2 }
  end
  context linux_kernel_parameter('net.ipv4.tcp_keepalive_intvl') do
    its(:value) { should eq 3 }
  end

  context linux_kernel_parameter('net.ipv4.tcp_window_scaling') do
    its(:value) { should eq 1 }
  end
  context linux_kernel_parameter('net.core.rmem_max') do
    its(:value) { should eq 16777216 }
  end
  context linux_kernel_parameter('net.core.wmem_max') do
    its(:value) { should eq 16777216 }
  end
  context linux_kernel_parameter('net.ipv4.tcp_rmem') do
    its(:value) { should match /4096\t349520\t16777216/ }
  end
  context linux_kernel_parameter('net.ipv4.tcp_wmem') do
    its(:value) { should match /4096\t65536\t16777216/ }
  end

  context linux_kernel_parameter('net.ipv4.tcp_no_metrics_save') do
    its(:value) { should eq 1 }
  end
  context linux_kernel_parameter('net.ipv4.conf.all.rp_filter') do
    its(:value) { should eq 1 }
  end
  context linux_kernel_parameter('net.ipv4.tcp_rfc1337') do
    its(:value) { should eq 1 }
  end
  context linux_kernel_parameter('net.ipv4.tcp_syncookies') do
    its(:value) { should eq 1 }
  end
  context linux_kernel_parameter('vm.overcommit_memory') do
    its(:value) { should eq 2 }
  end
  context linux_kernel_parameter('vm.overcommit_ratio') do
    its(:value) { should eq 99 }
  end
  context linux_kernel_parameter('kernel.panic') do
    its(:value) { should eq 30 }
  end
  context linux_kernel_parameter('vm.panic_on_oom') do
    its(:value) { should eq 1 }
  end

end
