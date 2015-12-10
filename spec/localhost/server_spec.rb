require 'spec_helper'

if property["server"] == 'apache' then

  describe package('httpd') do
    it { should be_installed }
  end

  describe package('httpd-devel') do
    it { should be_installed }
  end

  describe service('httpd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/httpd/conf/httpd.conf') do
    it { should be_file }
  end

  describe file('/etc/httpd/conf.d/www.conf'), :if => os[:release] == '7' do
    it { should be_file }
  end

  if property["server_tuning"] then

    describe file('/var/tmp/cache') do
     it { should be_directory }
     it { should be_mode 777 }
    end

    describe yumrepo('mod-pagespeed') do
      it { should exist }
    end

    describe file('/etc/httpd/conf.d/pagespeed.conf') do
     it { should be_file }
    end

  end

elsif property["server"] == 'nginx' then

  describe yumrepo('nginx') do
    it { should exist }
  end

  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
  end

  if property["server_tuning"] then

    describe file('/etc/nginx/conf.d/wordpress-tuning.conf') do
      it { should be_file }
    end

    describe file('/etc/nginx/conf.d/wordpress-multisite-tuning.conf') do
      it { should be_file }
    end

  else

    describe file('/etc/nginx/conf.d/wordpress.conf') do
      it { should be_file }
    end

    describe file('/etc/nginx/conf.d/wordpress-multisite.conf') do
      it { should be_file }
    end

  end

end

describe port(80) do
  it { should be_listening }
end
