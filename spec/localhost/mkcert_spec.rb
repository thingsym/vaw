require 'spec_helper'
require 'shellwords'

# require "pp"
# pp property

describe file('/etc/mkcert') do
  it { should be_directory }
end

if property["ssl"] then
  describe file("/etc/mkcert/cert.pem") do
    it { should be_file }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe file("/etc/mkcert/privkey.pem") do
    it { should be_file }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end
end
