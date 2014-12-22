require 'spec_helper'

if property["server"] == 'nginx' then

  if property["fastcgi"] == 'php-fpm' then

    describe package('php55u-fpm') do
      it { should be_installed }
    end

    describe service('php-fpm') do
      it { should be_enabled }
      it { should be_running }
    end

  elsif property["fastcgi"] == 'hhvm' then

    describe yumrepo('supervisor') do
      it { should exist }
    end

    describe service('supervisord') do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/var/run/hhvm') do
     it { should be_directory }
     it { should be_owned_by 'vagrant' }
     it { should be_grouped_into 'vagrant' }
    end

    describe yumrepo('hop5') do
      it { should exist }
    end

    describe package('hhvm') do
      it { should be_installed }
    end

    describe service('hhvm') do
      it { should be_running }
    end

    describe port(9000) do
      it { should be_listening }
    end

  end

end