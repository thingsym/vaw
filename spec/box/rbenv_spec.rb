require 'spec_helper'
require 'shellwords'

if property["develop_tools"] || property["deploy_tools"] then

  describe file('/home/vagrant/.rbenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe command('which rbenv') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.rbenv\/bin\/rbenv/) }
  end

  ['2.7.1'].each do |ruby_version|
    describe command("rbenv versions | grep #{ruby_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{Regexp.escape(ruby_version)}/) }
    end
  end

  describe command('which ruby') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.rbenv\/shims\/ruby/) }
  end

  describe command('ruby -v') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match '2.7.1' }
  end

  describe command('rbenv global') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match '2.7.1' }
  end

  describe file('/home/vagrant/.bashrc_vaw') do
    its(:content) { should match /export PATH=\$HOME\/\.rbenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(rbenv init \-\)"/ }
  end

  describe file('/home/vagrant/.rbenv/plugins/ruby-build') do
    it { should be_directory }
  end

  describe file('/home/vagrant/.rbenv/plugins/rbenv-default-gems') do
    it { should be_directory }
  end

  describe command('which gem') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.rbenv\/shims\/gem/) }
  end

  describe command('gem --version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe command('which bundler') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.rbenv\/shims\/bundler/) }
  end

  describe command('bundler --version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe package('libcurl') do
    it { should be_installed }
  end

  describe package('libcurl-devel') do
    it { should be_installed }
  end

  describe package('gcc') do
    it { should be_installed }
  end

  describe package('cmake') do
    it { should be_installed }
  end

  describe package('openssl-devel') do
    it { should be_installed }
  end

  describe package('libyaml-devel') do
    it { should be_installed }
  end

  describe package('readline-devel') do
    it { should be_installed }
  end

  describe package('zlib-devel') do
    it { should be_installed }
  end

end
