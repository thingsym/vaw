require 'spec_helper'

if property["ssl_admin"] then

  describe package('openssl') do
    it { should be_installed }
  end

elsif property["server"] == 'apache' && property["server_tuning"] then

  describe package('openssl') do
    it { should be_installed }
  end

end
