require 'spec_helper'
require 'shellwords'

# require "pp"
# pp property

if property["ssl"] then
  describe file("/vagrant/mkcert/cert.pem") do
    it { should be_file }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end

  describe file("/vagrant/mkcert/privkey.pem") do
    it { should be_file }
    it { should be_owned_by 'vagrant' }
    it { should be_grouped_into 'vagrant' }
  end
end
