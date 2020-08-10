# Changelog

## [0.7.3] - 2020.08.10

- add npm-installer.sh
- support php 7.4
- bump up ruby 2.7.1

## [0.7.2] - 2020.06.29

- add tree
- add forwarded_port for MailHog

## [0.7.1] - 2020.04.22

- improve openssl role
- bump up php 7.3.17
- bump up MariaDB 10.4
- change loop from with_items to a list of packages
- fix git2u obsoleted

## [0.7.0] - 2020.01.29

- fix IUS repository url

## [0.6.9] - 2019.11.20

- bump up node version
- fix php config with phpenv.sh
- fix IUS repository url

## [0.6.8] - 2019.10.02

- fix php config with phpenv.sh
- improve kernel parameter
- bump up php version
- fix php-build.default_configure_options
- add Zstandard compression algorithm

## [0.6.7] - 2019.07.19

- bump up php codesniffer
- fix httpd.conf
- add choice of openssl installation, source or package

## [0.6.6] - 2019.06.11

- improve to add forwarded_port using array
- fix IUS repository url
- fix kernel parameter
- add .editorconfig
- add mysqltuner.pl
- bump up git version 2 or later
- fix client_max_body_size
- fix http2 config
- enable switch between prefork and event with apache
- bump up Apache version 2.4
- improve version specification with openssl

## [0.6.5] - 2019.03.12

- modify kernel parameters
- remove hhvm

## [0.6.4] - 2019.01.23

- add CHANGELOG.md
- fix PHPUnit Selenium
- fix phpunit install

## [0.6.3] - 2018.10.17

- optimize vagrant box
- add wordpress plugin health-check
- add phpstan
- add peco
- add jq
- fix tests

## [0.6.2] - 2018.09.23

- fix tests
- fix gem install globally

## [0.6.1] - 2018.09.17

- separate files
- add multiple search-replace
- change to multiple search-replace for replace_old_url

## [0.6.0] - 2018.09.03

- enable ssl and https by default
- bump up ruby version 2.5.1
- bump up Node version 8.11.4

## [0.5.9] - 2018.08.02

- improve phpenv.sh version 0.4.1
- fix php-build.default_configure_options
- fix httpd.conf for apache mpm_event
- add other versions database tasks
- bump up MariaDB 10.3, MySQL 5.7, Percona 5.7

## [0.5.8] - 2018.05.27

- add deployer and git-ftp
- remove capistrano and fabric
- add handlers with web server
- add option synced_folder_type with Vagrant Settings

## [0.5.7] - 2018.05.13

- change module from command to gem/npm
- fix deprecated match filter
- remove mount_options
- fix vbguest_auto_update
- change official Vagrant box to official distributor
- change from yum claen all to yum makecache fast, only CentOS6
- fix default PHP version to 7.2.1
- fix defaults with wordpress task
- remove defaults with wp-cli task
- remove themes, plugins and import directories
- fix reset database tasks
- revert SELinux with CentOS7
- remove swap space
- fix -env path
- using 'become' and 'become_user' rather than running sudo
- add .bashrc_vaw
- remove bash settings into .bash_profile, integrate into .bashrc
- move documentation from docs to gh-pages branch

## [0.5.6] - 2018.03.25

- update vm_box
- add type option into config.vm.synced_folder
- bump up PHP version to 7.2.1
- fix mailhog handlers
- bump up daemonize version to 1.7.8
- improve daemonize installation
- remove CityFan repo
- add Exit Code into command
- add chrony with centos 7
- improve phpenv.sh version 0.1.2 for CentOS
- add mod_ssl
- change setting name from ssl_wp_admin to ssl
- fix ssl path
- fix self Certification Authority
- fix ruby build env
- remove rbenv-gem-rehash
- fix bundler via rbenv-default-gems
- change multiple conditions of the when statement to as a list
- change readme file name to upper case

## [0.5.5] - 2017.12.05

- add documentation

## [0.5.4] - 2017.11.19

- fix comment
- add WordPress plugin
- update theme-unit-test
- fix AllowOverride in httpd.conf for security plugins
- add default-character-set utf8mb4 with client section

## [0.5.3] - 2017.10.03

- fix comment
- change database charset from utf8 to utf8mb4
- add MailHog

## [0.5.2] - 2017.08.17

- bump up PHP version to 7.1.7
- fix phpenv.sh
- change setting name from ssl_admin to ssl_wp_admin
- enable sync-dir with before-command and after-command
- fixed version with PHPUnit, PHP_CodeSniffer and PHPUnit Selenium
- change label of provision_mode from normal to all
- change order of setting items
- fix settings format
- add .travis.yml
- fix vb.customize for improve VirutalBox performance
- remove vagrant-cachier plugin

## [0.5.1] - 2017.07.12

- fix php-cgi not found
- fix webserver and fastcgi owner/group
- remove bower
- add tests for box
- fix centos-box.sh
- change provision_only_wordpress mode to provision_mode
- rename certificate file and key
- fix libcurl installation

## [0.5.0] - 2017.06.20

- fix centos-box.sh
- fix vm_box, using public Vagrant boxes
- add CityFan repository for libcurl, only CentOS 6
- set permission to synced_folder wordpress
- change default database to mariadb from mysql
- fix server test
- fix php install via phpenv.sh
- add socket argument to phpenv.sh
- add fastcgi to apache
- improve phpenv.sh version 0.1.1 for CentOS
- add forwarded_port for Browsersync
- fix php post_max_size to 32M
- remove wp-phpcs ruleset
- add custom hhvm.server.ini
- bump up Ruby version to 2.4.1
- add webserver h2o
- change hhvm fastcgi connect to UNIX domain socket from TCP
- change webserver and fastcgi owner/group nobody
- add my.cnf for each database
- fix opcache disable
- add tests for sync-dir
- update activate plugins
- add wordpress import for backwpup
- add wp-content automatic place
- fix sendfile off

## [0.4.4] - 2017.03.18

- using YAML dictionaries in tasks
- add centos-box.sh

## [0.4.3] - 2017.03.07

- add custom ~/.ssh/config
- add only WordPress provision mode
- add ansible install_mode
- fix hhvm
- change filename extension from cert to crt
- add packagist.jp repository
- fix wp core config parameter
- add yarn
- add cachetool
- fix mysql and mariadb tasks
- add yum-utils
- fix database tests
- update percona-release-0.1-4.noarch.rpm
- fix my.cnf.j2
- fix httpd.conf when ssl enable
- add tests of wordpress
- replace from shell module to command module
- provision fail only when SELinux is Enforcing
- fix dest path of default_configure_options
- fix php.conf.j2
- bump up node version to 6.9.1
- fix default-node-packages.j2

## [0.4.2] - 2016.10.04

- add develop-tools role, fix build environment
- fix the inline script to get the major version number
- fix sudo user
- fix shebang

## [0.4.1] - 2016.09.10

- fix inline shell in Vagrantfile
- fix nodejs version

## [0.4.0] - 2016.08.22

- bump up php version to 7.0.7
- change to package module from yum module
- change default box to CentOS 7 from CentOS 6
- add synced_folder /vagrant
- add vagrant-vbguest
- change to yum_repository module from template module
- fix home_dir path into playbooks
- add phpenv-composer, remove composer role
- fix phpenv role
- add nodenv role, remove nodejs, npm
- change provision to ansible_local from inline shell
- remove RepoForge repository
- add webgrind
- add phpmd
- add prestissimo
- fix re2c via yum
- fix tests
- add gulp-cli and npm-check-updates, remove gulp globally
- change to become, since sudo has been deprecated
- fix phpenv.sh

## [0.3.3] - 2016.05.31

- fix playbooks
- remove compass gem
- refactoring phpenv.sh
- disable OPcache

## [0.3.2] - 2016.02.09

- add custom config
- remove server tuning

## [0.3.1] - 2016.01.18

- fix yum releasever version

## [0.3.0] - 2015.12.21

- fix Vagrantfile
- fix wp-cli role, compatible with WordPress 4.4
- improve hhvm role
- improve command phpenv.sh
- support CentOS 7 x86-64

## [0.2.1] - 2015.10.09

- add stylestats
- add plato

## [0.2.0] - 2015.08.31

- fix Fabric
- fix WordPress plugins
- fix rbenv and hhvm, MariaDB roles
- fix memory 1.5GB
- remove php55 and php-fpm roles
- add command phpenv.sh
- add phpenv role, replaced from php

## [0.1.8] - 2015.08.04

- fix WordPress plugins
- add PHPUnit Selenium

## [0.1.7] - 2015.07.06

- add public_network

## [0.1.6] - 2015.06.15

- add vm_box_version

## [0.1.5] - 2015.06.04

- add Fabric
- add wrk
- add command db_backup.sh
- nginx tuning

## [0.1.4] - 2015.04.29

- fix Ansible 1.9.x

## [0.1.3] - 2015.02.17

- fix fastcgi_spec.rb

## [0.1.2] - 2015.01.31

- change how to set the environment variables to .bash_profile
- fix Vagrantfile

## [0.1.1] - 2015.01.14

- change setting format
- fix yum repository metadata
- add WordPress options
- add sass and compass gems
- fix wp-cli role

## [0.1.0] - 2014.12.22

- initial release
