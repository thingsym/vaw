require 'spec_helper'
require 'shellwords'

describe file('/etc/udev/rules.d/70-persistent-net.rules') do
  it { should be_symlink }
end

describe file('/etc/sysconfig/network-scripts/ifcfg-eth1') do
  it { should_not exist }
end

describe file('/dev/.udev/') do
  it { should_not exist }
end

describe file('/lib/udev/rules.d/75-persistent-net-generator.rules') do
  it { should_not exist }
end

describe file('/etc/udev/rules.d/70-persistent-ipoib.rules') do
  it { should_not exist }
end
