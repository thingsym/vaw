require 'spec_helper'
require 'shellwords'

if property["import_admin"] then
  describe command("mysqlshow -u #{property["db_user"]} -p#{property["db_password"]} #{property["db_name"]}") do
    its(:stdout) { should match /#{property["db_name"]}/ }
  end
elsif property["import_db_data"] or property["import_backwpup"]["db_data_file"] then
  # Nothing to do
else
  describe command("mysqlshow -u #{property["db_user"]} -p#{property["db_password"]} #{property["db_name"]}") do
    its(:stdout) { should match /#{property["db_name"]}/ }
  end
end

describe file("/var/www/html#{property["wp_site_path"]}/wp-config.php") do
  it { should exist }
end

describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php") do
  it { should contain("define\( 'DB_NAME', '#{property["db_name"]}' \);") }
  it { should contain("define\( 'DB_USER', '#{property["db_user"]}' \);") }
  it { should contain("define\( 'DB_PASSWORD', '#{property["db_password"]}' \);") }
  it { should contain("define\( 'DB_CHARSET', '#{property["db_charset"]}' \);") }
  it { should contain("define\( 'DB_COLLATE', '#{property["db_collate"]}' \);") }
end

describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php"), :if => os[:release] == '6' do
  it { should contain("define\( 'DB_HOST', '#{property["db_host"]} '\);") }
end

describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php"), :if => os[:release] == '7' do
  it { should contain("define\( 'DB_HOST', '#{property["db_host"]}' \);") }
end

if property["WP_DEBUG"] then
  describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php") do
    it { should contain("define\( 'WP_DEBUG', True \);") }
  end
end

if property["SAVEQUERIES"] then
  describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php") do
    it { should contain("define\( 'SAVEQUERIES', True \);") }
  end
end

if property["ssl"] then
  describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php") do
    it { should contain("define\( 'FORCE_SSL_ADMIN', true \);") }
  end
end
