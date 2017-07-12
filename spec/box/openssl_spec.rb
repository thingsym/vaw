require 'spec_helper'
require 'shellwords'

if property["ssl_admin"] then

  describe package('openssl') do
    it { should be_installed }
  end

  describe file("/etc/pki/tls/vaw") do
    it { should be_directory }
  end

  describe file("/etc/pki/tls/vaw/server.key") do
    it { should be_file }
  end

  describe file("/etc/pki/tls/vaw/server.crt") do
    it { should be_file }
  end

end
