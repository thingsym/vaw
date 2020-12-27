require 'spec_helper'
require 'shellwords'

if property["ssl"] then

  describe package('openssl') do
    it { should be_installed }
  end

  describe command('openssl version') do
    its(:stdout) { should match /#{Regexp.escape('1.1.1g')}/ }
    its(:exit_status) { should eq 0 }
  end

  describe file("/etc/pki/tls/vaw") do
    it { should be_directory }
  end

  describe file("/etc/pki/tls/vaw/privkey.pem") do
    it { should be_file }
  end

  describe file("/etc/pki/tls/vaw/csr.pem") do
    it { should be_file }
  end

  describe file("/etc/pki/tls/vaw/crt.pem") do
    it { should be_file }
  end

end
