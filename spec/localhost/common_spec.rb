require 'spec_helper'

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
  it { should be_disabled }
end

describe service('iptables') do
  it { should_not be_enabled }
  it { should_not be_running }
end

describe package('ntp') do
  it { should be_installed }
end

describe service('ntpd') do
  it { should be_enabled }
end

describe service('ntp') do
  it { should be_running }
end

describe yumrepo('epel') do
  it { should exist }
end

describe yumrepo('rpmforge') do
  it { should exist }
end

describe yumrepo('ius') do
  it { should exist }
end

describe command('ansible --version') do
  its(:exit_status) { should eq 0 }
end
