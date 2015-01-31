require 'spec_helper'

if property["develop_tools"] || property["deploy_tools"] then

  ['2.1.4'].each do |ruby_version|
    describe command("rbenv versions | grep #{ruby_version}") do
      let(:disable_sudo) { true }
      let(:path) { '~/.rbenv/bin' }
      its(:stdout) { should match(/#{Regexp.escape(ruby_version)}/) }
    end
  end

  describe command('rbenv global') do
    let(:disable_sudo) { true }
    let(:path) { '~/.rbenv/bin' }
    its(:stdout) { should match '2.1.4' }
  end

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /export PATH=\$HOME\/\.rbenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(rbenv init \-\)"/ }
  end

  describe file('/home/vagrant/.rbenv/plugins/ruby-build') do
    it { should be_directory }
  end

  describe file('/home/vagrant/.rbenv/plugins/rbenv-gem-rehash') do
    it { should be_directory }
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
