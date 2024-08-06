require 'spec_helper'
require 'shellwords'

describe package('git236'), :if => os[:family] == 'redhat' && os[:release] <= '7' do
  it { should be_installed }
end

describe package('git'), :if => (os[:family] == 'redhat' && os[:release] >= '8') || os[:family] == 'debian' || os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe command('which git') do
  let(:sudo_options) { '-u vagrant -i' }
  its(:exit_status) { should eq 0 }
end
