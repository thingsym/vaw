require 'spec_helper'

if property["server"] == 'nginx' then

  if property["fastcgi"] == 'php-fpm' then

    describe file('/var/run/php-fpm') do
      it { should be_directory }
      it { should be_owned_by 'nginx' }
      it { should be_grouped_into 'nginx' }
    end

    describe file('/var/log/php-fpm') do
      it { should be_directory }
      it { should be_owned_by 'nobody' }
      it { should be_grouped_into 'nobody' }
    end

    describe file('/usr/sbin/php-fpm') do
      it { should be_file }
      it { should be_mode 755 }
    end

    describe file('/etc/init.d/php-fpm') do
      it { should be_file }
      it { should be_mode 755 }
    end

    describe command('php-fpm -v') do
      let(:disable_sudo) { true }
      let(:path) { '/usr/sbin' }
      its(:exit_status) { should eq 0 }
    end

    describe service('php-fpm') do
      it { should be_enabled }
      it { should be_running }
    end

  elsif property["fastcgi"] == 'hhvm' then

    describe package('supervisor') do
      it { should be_installed }
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