require 'spec_helper'
require 'shellwords'

describe package('patch') do
  it { should be_installed }
end

describe package('yum-utils'), :if => os[:family] == 'redhat' do
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
