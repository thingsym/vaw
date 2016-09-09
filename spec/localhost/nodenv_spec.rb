require 'spec_helper'
require 'shellwords'

if property["develop_tools"] then

  ['4.5.0'].each do |node_version|
    describe command("nodenv versions | grep #{node_version}") do
      let(:disable_sudo) { true }
      its(:stdout) { should match(/#{Regexp.escape(node_version)}/) }
    end
  end

  describe command('node -v') do
    let(:disable_sudo) { true }
    its(:stdout) { should match '4.5.0' }
  end

  describe command('nodenv global') do
    let(:disable_sudo) { true }
    its(:stdout) { should match '4.5.0' }
  end

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /export PATH=\$HOME\/\.nodenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(nodenv init \-\)"/ }
  end

  describe file('/home/vagrant/.bashrc') do
    its(:content) { should match /export PATH=\$HOME\/\.nodenv\/bin:\$PATH/ }
    its(:content) { should match /eval "\$\(nodenv init \-\)"/ }
  end

  describe file('/home/vagrant/.nodenv/plugins/node-build') do
    it { should be_directory }
  end

  describe file('/home/vagrant/.nodenv/plugins/nodenv-default-packages') do
    it { should be_directory }
  end

  describe command('npm -v') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end
end
