require 'spec_helper'

if property["ssl_admin"] then

  describe package('openssl') do
    it { should be_installed }
  end

end
