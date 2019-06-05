require 'spec_helper'
require 'shellwords'

describe package('git2u'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('git'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe command('which git') do
  let(:sudo_options) { '-u vagrant -i' }
  its(:exit_status) { should eq 0 }
end
