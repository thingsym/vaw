require 'spec_helper'
require 'shellwords'

if property["database"] == 'mysql' then

  describe command('mysqld -V'), :if => os[:family] == 'redhat' || os[:family] == 'debian' || (os[:family] == 'ubuntu' && os[:release] == '14.04') do
    its(:stdout) { should match /#{Regexp.escape('5.7')}/ }
  end

  describe command('mysqld -V'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    its(:stdout) { should match /#{Regexp.escape('5.7')}/ }
  end

  describe package('mysql-community-server'), :if => os[:family] == 'redhat' do
    it { should be_installed }
    it { should be_installed.with_version '5.7' }
  end

  describe package('mysql-community-server'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe yumrepo('mysql57-community'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe service('mysqld'), :if => os[:family] == 'redhat' do
    it { should be_enabled }
  end

  describe service('mysql'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_running }
  end

  describe service('mysqld'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_running }
  end

  describe command('apt-cache policy | grep mysql-5.7'), :if => os[:family] == 'debian' || (os[:family] == 'ubuntu' && os[:release] == '14.04') do
    its(:stdout) { should match /#{Regexp.escape('mysql-5.7')}/ }
  end

  describe command('apt-cache policy | grep mysql-5.7'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    its(:stdout) { should match /#{Regexp.escape('mysql-5.7')}/ }
  end

  describe service('mysql'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_enabled }
    it { should be_running }
  end

elsif property["database"] == 'mariadb' then

  describe command('mysqld -V') do
    its(:stdout) { should match /#{Regexp.escape('10.4')}/ }
  end

  describe yumrepo('mariadb'), :if => os[:family] == 'redhat' do
    it { should exist }
  end

  describe package('MariaDB-server'), :if => os[:family] == 'redhat' do
    it { should be_installed }
    it { should be_installed.with_version '10.4' }
  end

  describe service('mysql'), :if => os[:family] == 'redhat' && os[:release] == '6' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mariadb'), :if => os[:family] == 'redhat' && os[:release] == '7' do
    it { should be_enabled }
    it { should be_running }
  end

  describe package('mariadb-server-10.4'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe command('apt-cache policy | grep mariadb'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    its(:stdout) { should match /#{Regexp.escape('mariadb')}/ }
  end

  describe service('mariadb'), :if => os[:family] == 'debian' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mariadb'), :if => os[:family] == 'ubuntu' && os[:release] == '16.04' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mysql'), :if => os[:family] == 'ubuntu' && os[:release] == '14.04' do
    it { should be_enabled }
    it { should be_running }
  end

end

if property["database"] == 'mysql' || property["database"] == 'mariadb' then
  describe file('/etc/my.cnf'), :if => os[:family] == 'redhat' do
    it { should be_file }
    it { should contain("skip-character-set-client-handshake") }
  end

  describe file('/etc/mysql/my.cnf'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_file }
    it { should contain("skip-character-set-client-handshake") }
  end

  describe 'MySQL config parameters' do
    context mysql_config('socket') do
      its(:value) { should eq '/tmp/mysql.sock' }
    end

    context mysql_config('character-set-server') do
      its(:value) { should eq 'utf8mb4' }
    end
  end

  describe file('/tmp/mysql.sock') do
    it { should be_socket }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end

  describe port(3306) do
    it { should be_listening }
  end

  describe command("mysqlshow -uroot -p'#{property["db_root_password"]}' mysql") do
    its(:stdout) { should match /Database: mysql/ }
  end

  describe command( "mysqladmin -uroot -p'#{property["db_root_password"]}' ping" ) do
    its(:stdout) { should match /mysqld is alive/ }
  end

  describe package('MySQL-python'), :if => os[:family] == 'redhat' && (os[:release] == '6' || os[:release] == '7') do
    it { should be_installed }
  end

  describe package('python2-PyMySQL'), :if => os[:family] == 'redhat' && (os[:release] == '8') do
    it { should be_installed }
  end
  describe package('python3-PyMySQL'), :if => os[:family] == 'redhat' && (os[:release] == '8') do
    it { should be_installed }
  end

  describe package('python-mysqldb'), :if => os[:family] == 'debian' || os[:family] == 'ubuntu' do
    it { should be_installed }
  end

  describe package('python3-mysqldb'), :if => os[:family] == 'ubuntu' && os[:release] == '20.04' do
    it { should be_installed }
  end

  describe file('/var/log/mysql') do
    it { should be_directory }
    it { should be_owned_by 'mysql' }
    it { should be_grouped_into 'mysql' }
  end
end
