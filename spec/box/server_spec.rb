require 'spec_helper'
require 'shellwords'

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

  describe command("httpd -M | grep 'proxy_fcgi_module'") do
    its(:stdout) { should match(/proxy_fcgi_module/) }
  end

  if os[:release] =~ /^6/ then
    describe package('mod_proxy_fcgi') do
      it { should be_installed }
    end

    describe command("httpd -V | grep 'Server MPM'") do
      its(:stdout) { should match(/Prefork/) }
    end

    describe command("httpd -M | grep 'mpm_prefork_module'") do
      its(:stdout) { should match(/mpm_prefork_module/) }
    end
  end

  if os[:release] =~ /^7/ then
    if property["fastcgi"] == 'none' then
      describe command("httpd -V | grep 'Server MPM'") do
        its(:stdout) { should match(/prefork/) }
      end

      describe command("httpd -M | grep 'mpm_prefork_module'") do
        its(:stdout) { should match(/mpm_prefork_module/) }
      end
    end
  end

  if property["fastcgi"] == 'none' then
    if property["php_version"] =~ /^7/ then
      describe command("httpd -M | grep 'php7_module'") do
        its(:stdout) { should match(/php7_module/) }
      end
    end
    if property["php_version"] =~ /^5/ then
      describe command("httpd -M | grep 'php5_module'") do
        its(:stdout) { should match(/php5_module/) }
      end
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

  if property["multisite"] then
    describe file('/etc/nginx/conf.d/wordpress-multisite.conf') do
      it { should be_file }
    end
  else
    describe file('/etc/nginx/conf.d/wordpress.conf') do
      it { should be_file }
    end
  end

elsif property["server"] == 'h2o' then

  describe yumrepo('bintray-tatsushid-h2o-rpm'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('h2o') do
    it { should be_installed }
  end

  describe service('h2o') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/h2o/h2o.conf') do
    it { should be_file }
  end

  describe file('/var/run/h2o') do
    it { should be_directory }
  end

end

describe port(80) do
  it { should be_listening }
end
