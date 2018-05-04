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
