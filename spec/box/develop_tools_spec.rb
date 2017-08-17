require 'spec_helper'
require 'shellwords'

describe package('yum-utils'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('curl') do
  it { should be_installed }
end

describe yumrepo('city-fan'), :if => os[:family] == 'redhat' && os[:release] == '6' do
  it { should exist }
end

describe package('libcurl') do
  it { should be_installed }
end

describe package('libcurl-devel') do
  it { should be_installed }
end
