require 'spec_helper'
require 'shellwords'

if property["server"] == 'apache' then

  describe package('httpd24u'), :if => os[:family] == 'redhat' && (os[:release] <= '7') do
    it { should be_installed }
  end

  describe package('httpd24u-devel'), :if => os[:family] == 'redhat' && (os[:release] <= '7') do
    it { should be_installed }
  end

  describe package('httpd'), :if => os[:family] == 'redhat' && os[:release] >= '8' do
    it { should be_installed }
  end

  describe package('httpd-devel'), :if => os[:family] == 'redhat' && os[:release] >= '8' do
    it { should be_installed }
  end

  describe command("apachectl -M | grep 'proxy_fcgi_module'") do
    its(:stdout) { should match(/proxy_fcgi_module/) }
  end

  describe package('mod_proxy_fcgi'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_installed }
  end

  if property["ssl"] then
    describe package('httpd24u-mod_ssl'), :if => os[:family] == 'redhat' && (os[:release] <= '7') do
      it { should be_installed }
    end

    describe package('mod_ssl'), :if => os[:family] == 'redhat' && os[:release] >= '8' do
      it { should be_installed }
    end

    describe command("apachectl -M | grep 'ssl_module'") do
      its(:stdout) { should match(/ssl_module/) }
    end

    describe command("apachectl -M | grep 'http2_module'") do
      its(:stdout) { should match(/http2_module/) }
    end
  end

  describe service('httpd'), :if => os[:family] == 'redhat' do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("apachectl -M | grep 'mpm_prefork_module'"), :if => property["apache_mpm"] == 'prefork' do
    its(:stdout) { should match(/mpm_prefork_module/) }
  end

  describe command("apachectl -M | grep 'mpm_event_module'"), :if => property["apache_mpm"] == 'event' do
    its(:stdout) { should match(/mpm_event_module/) }
  end

  describe command("apachectl -V | grep -i mpm"), :if => property["apache_mpm"] == 'prefork' do
    its(:stdout) { should match /prefork/ }
  end

  describe command("apachectl -V | grep -i mpm"), :if => property["apache_mpm"] == 'event' do
    its(:stdout) { should match /event/ }
  end

  describe command("ps -C httpd -o user"), :if => os[:family] == 'redhat' do
    its(:stdout) { should match /vagrant/ }
  end

  describe file('/etc/httpd/conf/httpd.conf'), :if => os[:family] == 'redhat' do
    it { should be_file }
  end

  describe file('/etc/httpd/conf.d/www.conf'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_file }
  end

  describe file('/etc/httpd/conf.modules.d/00-http2.conf'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_file }
  end

  describe package('apache2'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('apache2-dev'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe service('apache2'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("ps -C apache2 -o user"), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    its(:stdout) { should match /vagrant/ }
  end

  describe file('/etc/apache2/apache2.conf'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_file }
  end

  describe file('/etc/apache2/sites-available/000-default.conf'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_file }
  end

  describe file('/etc/apache2/sites-available/default-ssl.conf'), :if => ( os[:family] == 'debian' || os[:family] == 'ubuntu' ) && property["ssl"] do
    it { should be_file }
  end

  if property["fastcgi"] == 'none' then
    if property["php_version"] =~ /^7/ then
      describe command("apachectl -M | grep 'php7_module'") do
        its(:stdout) { should match(/php7_module/) }
      end
    end
    if property["php_version"] =~ /^5/ then
      describe command("apachectl -M | grep 'php5_module'") do
        its(:stdout) { should match(/php5_module/) }
      end
    end
  end

elsif property["server"] == 'nginx' then

  describe yumrepo('nginx'), :if => os[:family] == 'redhat' && os[:release] <= '7' do
    it { should exist }
  end

  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command("ps -C nginx -o user") do
    its(:stdout) { should match /vagrant/ }
  end

  describe file('/etc/nginx/nginx.conf') do
    it { should be_file }
  end

  describe file('/etc/nginx/conf.d/www.conf') do
    it { should be_file }
  end

  # describe command("nginx -V") do
  #   its(:stdout) { should match /http_v2_module/ }
  # end

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

  describe command("ps -C h2o -o user") do
    its(:stdout) { should match /vagrant/ }
  end

  if property["fastcgi"] == 'php-fpm' then
    describe command("ps -C php-cgi -o user") do
      its(:stdout) { should match /vagrant/ }
    end
  end

  describe file('/etc/h2o/h2o.conf') do
    it { should be_file }
  end

  describe file('/var/run/h2o') do
    it { should be_directory }
  end

elsif property["server"] == 'litespeed' then

  describe yumrepo('litespeed'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe yumrepo('litespeed-update'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('openlitespeed') do
    it { should be_installed }
  end

  describe service('lsws') do
    it { should be_enabled }
    # it { should be_running }
  end

end

if property["server"] != 'none' && property["server"] != 'litespeed' then
  describe port(80) do
    it { should be_listening }
  end

  if property["ssl"] then
    describe port(443) do
      it { should be_listening }
    end
  end
end
