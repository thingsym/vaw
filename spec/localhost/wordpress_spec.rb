require 'spec_helper'
require 'shellwords'

describe command("mysqlshow -u #{property["db_user"]} -p#{property["db_password"]} #{property["db_name"]}") do
  its(:stdout) { should match /#{property["db_name"]}/ }
end

describe file("/var/www/html#{property["wp_site_path"]}/wp-config.php") do
  it { should exist }
end

describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php") do
  it { should contain("define\('DB_NAME', '#{property["db_name"]}'\);") }
  it { should contain("define\('DB_USER', '#{property["db_user"]}'\);") }
  it { should contain("define\('DB_PASSWORD', '#{property["db_password"]}'\);") }
end

describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php"), :if => os[:release] == '6' do
  it { should contain("define\('DB_HOST', '#{property["db_host"]}'\);") }
end

describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php"), :if => os[:release] == '7' do
  it { should contain("define\('DB_HOST', '#{property["db_host"]}:/var/lib/mysql/mysql.sock'\);") }
end

if property["WP_DEBUG"] == 'true' then
  describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php") do
    it { should contain("define\( 'WP_DEBUG', True \);") }
  end
end

if property["SAVEQUERIES"] == 'true' then
  describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php") do
    it { should contain("define\( 'SAVEQUERIES', True \);") }
  end
end

if property["ssl_admin"] == 'true' then
  describe file("/var/www/html#{property["wp_site_path"]}#{property["wp_dir"]}/wp-config.php") do
    it { should contain("define\( 'FORCE_SSL_ADMIN', true \);") }
  end
end
