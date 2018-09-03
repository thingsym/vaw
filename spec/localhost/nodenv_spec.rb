require 'spec_helper'
require 'shellwords'

if property["develop_tools"] then

  ['8.11.4'].each do |node_version|
    describe command("nodenv versions | grep #{node_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{Regexp.escape(node_version)}/) }
    end
  end

  describe command('node -v') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match '8.11.4' }
  end

  describe command('nodenv global') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match '8.11.4' }
  end

  describe file('/home/vagrant/.bashrc_vaw') do
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
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end
end
