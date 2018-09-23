require 'spec_helper'
require 'shellwords'

if property["develop_tools"] then

  describe file('/home/vagrant/.nodenv/') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe command('which nodenv') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/bin\/nodenv/) }
  end

  ['8.11.4'].each do |node_version|
    describe command("nodenv versions | grep #{node_version}") do
      let(:sudo_options) { '-u vagrant -i' }
      its(:stdout) { should match(/#{Regexp.escape(node_version)}/) }
    end
  end

  describe command('which node') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/shims\/node/) }
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

  describe command('which npm') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/shims\/npm/) }
  end

  describe command('npm -v') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end
end
