require 'spec_helper'
require 'shellwords'

describe package('patch') do
  it { should be_installed }
end

describe package('yum-utils'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('build-essential'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('software-properties-common'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('python3-pip'), :if => os[:family] == 'redhat' && os[:release] >= '8' do
  it { should be_installed }
end

describe package('python2-pip'), :if => os[:family] == 'redhat' && os[:release] == '7' do
  it { should be_installed }
end

describe package('python-pip'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  it { should be_installed }
end

describe package('python3-pip'), :if => os[:family] == 'ubuntu' && os[:release] == '20.04' do
  it { should be_installed }
end

describe package('python-pip'), :if => os[:family] == 'ubuntu' && os[:release] == '18.04' do
  it { should be_installed }
end

describe package('python-pip'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
  it { should be_installed }
end

describe package('python-pip'), :if => os[:family] == 'debian' do
  it { should be_installed }
end

describe package('pkg-config'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('debconf-utils'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('curl') do
  it { should be_installed }
end

describe package('libcurl'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('libcurl-devel'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('jq') do
  it { should be_installed }
end

describe package('tree') do
  it { should be_installed }
end

describe package('ca-certificates'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe package('gnupg-agent'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe command('which peco') do
  let(:sudo_options) { '-u vagrant -i' }
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/\/usr\/local\/bin\/peco/) }
end

describe command('peco --version') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
end

describe package('zstd') do
  it { should be_installed }
end
