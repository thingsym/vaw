require 'spec_helper'

if property["develop_tools"] then

  describe package('gettext') do
    it { should be_installed }
  end

  describe package('subversion') do
    it { should be_installed }
  end

  describe package('nodejs') do
    it { should be_installed }
  end

  describe package('npm') do
    it { should be_installed }
  end

  describe package('sass') do
    let(:disable_sudo) { true }
    it { should be_installed.by('gem') }
  end

  describe package('compass') do
    let(:disable_sudo) { true }
    it { should be_installed.by('gem') }
  end

  describe command('grunt --version') do
   its(:exit_status) { should eq 0 }
  end

  describe command('grunt-init --version') do
   its(:exit_status) { should eq 0 }
  end

  describe command('gulp --version') do
   its(:exit_status) { should eq 0 }
  end

  describe command('bower --version') do
   its(:exit_status) { should eq 0 }
  end

  describe file('/usr/local/share/wp-i18n/makepot.php') do
    it { should be_file }
  end

  describe file('/home/vagrant/.bash_profile') do
    its(:content) { should match /alias makepot\.php="\/usr\/bin\/php \/usr\/local\/share\/wp\-i18n\/makepot\.php"/ }
  end

  describe command('phpunit --version') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end

  describe command('phpcs --version') do
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

  describe command('plato --version') do
   its(:exit_status) { should eq 0 }
  end

  describe command('stylestats --version') do
   its(:exit_status) { should eq 0 }
  end

end
