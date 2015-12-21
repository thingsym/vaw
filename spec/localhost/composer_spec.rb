require 'spec_helper'

describe command('composer --version') do
  let(:disable_sudo) { true }
  its(:exit_status) { should eq 0 }
end

describe file('/home/vagrant/.bash_profile') do
  its(:content) { should match /export PATH=\$HOME\/\.composer\/vendor\/bin:\$PATH/ }
end

describe file('/home/vagrant/.bashrc') do
  its(:content) { should match /export PATH=\$HOME\/\.composer\/vendor\/bin:\$PATH/ }
end