require 'spec_helper'
require 'shellwords'

if property["develop_tools"] then

  describe package('gettext') do
    it { should be_installed }
  end

  describe package('subversion') do
    it { should be_installed }
  end

  describe package('sass') do
    let(:disable_sudo) { true }
    it { should be_installed.by('gem') }
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

  describe command('which stylestats') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/shims\/stylestats/) }
  end

  describe command('stylestats --version') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
  end

  describe command('which plato') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.nodenv\/shims\/plato/) }
  end

  describe command('plato --version') do
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

  describe command('which phpunit') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.phpenv\/shims\/phpunit/) }
  end

  if property["php_version"] =~ /^7/ then
    describe command('phpunit --version') do
      let(:disable_sudo) { true }
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /^PHPUnit 5\.7/ }
    end
  end

  if property["php_version"] =~ /^5/ then
    describe command('phpunit --version') do
      let(:disable_sudo) { true }
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match /^PHPUnit 4\.8/ }
    end
  end

  describe command('which phpcs') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.phpenv\/shims\/phpcs/) }
  end

  describe command('phpcs --version') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^PHP_CodeSniffer version 2\.9/ }
  end

  describe command('phpcs -i') do
    let(:disable_sudo) { true }
    its(:stdout) { should match /WordPress\-Core/ }
  end

  describe command('which phpcbf') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.phpenv\/shims\/phpcbf/) }
  end

  describe command('phpcbf --version') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /^PHP_CodeSniffer version 2\.9/ }
  end

  describe command('cachetool -V') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end

  describe file('/home/vagrant/.phpenv/versions/' + property["php_version"] + '/composer/vendor/squizlabs/php_codesniffer') do
    it { should be_directory }
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

  describe command('which phpmd') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.phpenv\/shims\/phpmd/) }
  end

  describe command('phpmd --version') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
  end

  describe command('which phpstan') do
    let(:sudo_options) { '-u vagrant -i' }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/\/home\/vagrant\/\.phpenv\/shims\/phpstan/) }
  end

  describe command('phpstan --version') do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
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

end
