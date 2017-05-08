require 'spec_helper'
require 'shellwords'

if property["develop_tools"] then

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

  describe file('/var/www/html/webgrind/index.php') do
    it { should be_file }
  end

end
