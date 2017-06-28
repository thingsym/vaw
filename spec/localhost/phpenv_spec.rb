require 'spec_helper'
require 'shellwords'

describe file('/home/vagrant/.phpenv/') do
  it { should be_directory }
  it { should be_owned_by 'vagrant' }
  it { should be_grouped_into 'vagrant' }
end

[property["php_version"]].each do |php_version|
  describe command("phpenv versions | grep #{php_version}") do
    let(:sudo_options) { '-u vagrant -i' }
    its(:stdout) { should match(/#{Regexp.escape(php_version)}/) }
  end
end

describe command('phpenv global') do
  let(:sudo_options) { '-u vagrant -i' }
  its(:stdout) { should match /#{property["php_version"]}/ }
end

describe file('/home/vagrant/.bashrc') do
  its(:content) { should match /export PATH=\$HOME\/\.phpenv\/bin:\$PATH/ }
  its(:content) { should match /eval "\$\(phpenv init \-\)"/ }
end

describe file('/home/vagrant/.bash_profile') do
  its(:content) { should match /export PATH=\$HOME\/\.phpenv\/bin:\$PATH/ }
  its(:content) { should match /eval "\$\(phpenv init \-\)"/ }
end

describe file('/home/vagrant/.phpenv/plugins/php-build') do
  it { should be_directory }
end

describe command('composer --version') do
  let(:sudo_options) { '-u vagrant -i' }
  its(:exit_status) { should eq 0 }
end

describe file('/home/vagrant/.phpenv/versions/' + property["php_version"] + '/composer/vendor/hirak/prestissimo') do
  it { should be_directory }
end
if property["server"] == 'apache' then

  describe file('/home/vagrant/.phpenv/plugins/phpenv-apache-version') do
    it { should be_directory }
  end

  describe file('/etc/httpd/conf.d/php.conf') do
    it { should be_file }
  end

end

describe file('/home/vagrant/.phpenv/plugins/php-build/share/php-build/default_configure_options') do
  it { should be_file }
end

describe file('/var/log/php.log') do
  it { should be_file }
  it { should be_mode 666 }
end

describe command('php -v | grep PHP') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match /#{property["php_version"]}/ }
end

describe 'PHP config parameters' do
  context php_config('memory_limit') do
    its(:value) { should eq '128M' }
  end

  context php_config('error_reporting') do
    its(:value) { should eq 32767 }
  end

  context php_config('display_errors') do
    its(:value) { should eq 1 }
  end

  context php_config('post_max_size') do
    its(:value) { should eq '32M' }
  end

  context php_config('upload_max_filesize') do
    its(:value) { should eq '32M' }
  end

  context  php_config('default_charset') do
    its(:value) { should eq 'UTF-8' }
  end

  context  php_config('mbstring.language') do
    its(:value) { should eq 'neutral' }
  end

  context  php_config('mbstring.internal_encoding') do
    its(:value) { should eq 'UTF-8' }
  end

  context php_config('date.timezone') do
    its(:value) { should eq 'UTC' }
  end

  context php_config('session.save_path') do
    its(:value) { should eq '/tmp' }
  end

  context php_config('default_mimetype') do
    its(:value) { should match /text\/html/ }
  end

  context php_config('opcache.enable_cli') do
    its(:value) { should eq 0 }
  end

  context php_config('opcache.enable') do
    its(:value) { should eq 0 }
  end

end

describe package('patch') do
  it { should be_installed }
end

describe package('libxml2-devel') do
  it { should be_installed }
end

describe package('bison') do
  it { should be_installed }
end

describe package('bison-devel') do
  it { should be_installed }
end

describe package('re2c') do
  it { should be_installed }
end

describe package('openssl-devel') do
  it { should be_installed }
end

describe package('libcurl') do
  it { should be_installed }
end

describe package('libcurl-devel') do
  it { should be_installed }
end

# describe package('libjpeg-devel') do
#   it { should be_installed }
# end

describe package('libpng-devel') do
  it { should be_installed }
end

describe package('libmcrypt-devel') do
  it { should be_installed }
end

describe package('readline-devel') do
  it { should be_installed }
end

describe package('libtidy-devel') do
  it { should be_installed }
end

describe package('libxslt-devel') do
  it { should be_installed }
end
