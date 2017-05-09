require 'spec_helper'
require 'shellwords'

if property["database"] == 'mysql' then

  describe yumrepo('mysql56-community') do
    it { should exist }
  end

  describe package('mysql-community-server') do
    it { should be_installed }
    it { should be_installed.with_version '5.6' }
  end

  describe service('mysqld') do
    it { should be_enabled }
  end

  describe service('mysql'), :if => os[:release] == '6' do
    it { should be_running }
  end

  describe service('mysqld'), :if => os[:release] == '7' do
    it { should be_running }
  end

elsif property["database"] == 'mariadb' then

  describe yumrepo('mariadb') do
    it { should exist }
  end

  describe package('MariaDB-server') do
    it { should be_installed }
    it { should be_installed.with_version '10.1' }
  end

  describe service('mysql'), :if => os[:release] == '6' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mariadb'), :if => os[:release] == '7' do
    it { should be_enabled }
    it { should be_running }
  end

elsif property["database"] == 'percona' then

  describe yumrepo('percona-release-noarch') do
    it { should exist }
  end

  describe package('Percona-Server-server-56') do
    it { should be_installed }
    it { should be_installed.with_version '5.6' }
  end

  describe service('mysql'), :if => os[:release] == '6' do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('mysqld'), :if => os[:release] == '7' do
    it { should be_enabled }
    it { should be_running }
  end

end

describe file('/etc/my.cnf') do
  it { should be_file }
end

describe file("/etc/my.cnf") do
  it { should contain("character-set-server = utf8") }
  it { should contain("skip-character-set-client-handshake") }
end

describe port(3306) do
  it { should be_listening }
end

describe command("mysqlshow -u root -p#{property["db_root_password"]} mysql") do
  its(:stdout) { should match /Database: mysql/ }
end

describe command( "mysqladmin -u root -p#{property["db_root_password"]} ping" ) do
  its(:stdout) { should match /mysqld is alive/ }
end
