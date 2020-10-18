require 'spec_helper'
require 'shellwords'

if property["develop_tools"] then

  describe package('gettext') do
    it { should be_installed }
  end

  describe package('subversion') do
    it { should be_installed }
  end

  describe command('which grunt') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/shims\/grunt/) }
  end

  describe command('grunt --version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe command('grunt-init --version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe command('which gulp') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/shims\/gulp/) }
  end

  describe command('gulp --version') do
    let(:sudo_options) { '-u vagrant -i' }
   its(:exit_status) { should eq 0 }
  end

  describe command('which ncu') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/shims\/ncu/) }
  end

  command('ncu --version') do
    let(:sudo_options) { '-u vagrant -i' }
   its(:exit_status) { should eq 0 }
  end

  describe command('which npm-check-updates') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/shims\/npm-check-updates/) }
  end

  describe command('npm-check-updates --version') do
    let(:sudo_options) { '-u vagrant -i' }
   its(:exit_status) { should eq 0 }
  end

  describe command('yarn --version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe file('/usr/local/share/wp-i18n/makepot.php') do
    it { should be_file }
  end

  describe file('/home/vagrant/.bashrc_vaw') do
    its(:content) { should match /alias makepot\.php="\/usr\/bin\/php \/usr\/local\/share\/wp\-i18n\/makepot\.php"/ }
  end

  describe command('cachetool -V') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end

  describe file('/var/www/html/opcache') do
    it { should be_directory }
  end

  describe file('/var/www/html/opcache/opcache.php') do
    it { should be_file }
  end
  describe file('/var/www/html/opcache/op.php') do
    it { should be_file }
  end
  describe file('/var/www/html/opcache/ocp.php') do
    it { should be_file }
  end

  describe file('/usr/local/bin/wrk') do
    it { should be_file }
    it { should be_executable }
  end

  describe file('/var/www/html/webgrind/index.php') do
    it { should be_file }
  end

  describe command('mailhog -version') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end

  describe command('which mhsendmail') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end

  describe port(1025) do
    it { should be_listening }
  end

  describe port(8025) do
    it { should be_listening }
  end

  describe command('/usr/sbin/daemonize'), :if => os[:release] == '6' do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end

  describe file('/usr/local/bin/mysqltuner.pl') do
    it { should be_file }
    it { should be_executable }
  end
end
