require 'spec_helper'
require 'shellwords'

if property["deploy_tools"] then

  describe package('sshpass') do
    it { should be_installed }
  end

  describe package('lftp') do
    it { should be_installed }
  end

  describe package('python2-pip'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_installed }
  end

  describe package('python-pip'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_installed }
  end

  describe package('net-sftp') do
    let(:disable_sudo) { true }
    it { should be_installed.by('gem') }
  end

  describe package('double-bag-ftps') do
    let(:disable_sudo) { true }
    it { should be_installed.by('gem') }
  end

  describe package('dandelion') do
    let(:disable_sudo) { true }
    it { should be_installed.by('gem') }
  end

  describe package('wordmove') do
    let(:disable_sudo) { true }
    it { should be_installed.by('gem') }
  end

end
