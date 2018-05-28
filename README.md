# VAW (Vagrant Ansible WordPress)

The **VAW (Vagrant Ansible WordPress)** is **Ansible playbooks** for website developer, designer, webmaster and WordPress theme/plugin developer.

Launch the development environment in Vagrant, you can build the website and verify the operation of the website. Of course, you can also develop WordPress themes and plugins.

The **VAW** is also a collaboration tool. You can take advantage of collaboration tool that share the environment with development partners, designers and clients.

VAW (Vagrant Ansible WordPress) documentation: [https://thingsym.github.io/vaw/](https://thingsym.github.io/vaw/)

## Features

### 1. Build Server and Database environment

The **VAW** will build server from **Apache**, **nginx** or **H2O**, and build database from **MariaDB**, **MySQL** or **Percona MySQL**.

On all web servers, FastCGI configuration is possible. Build PHP execution environment from **PHP-FPM** (FastCGI Process Manager) or **HHVM** (HipHop Virtual Machine).

By default, the server and the databese is installed in the default settings. Also you can edit configuration files.

You can validate on the server and the database of various combinations.

### 2. Build WordPress environment

The **VAW** will build a WordPress which has been processed in a variety of settings and data.

You can verify the test data or real data on WordPress. The VAW will realize building of WordPress synchronized with the data and files in the production environment.

* Install specified version WordPress Core
* Install WordPress Core in Your Language
* Install to specified directory, or subdirectory install
* Multisite support
* Administration Over SSL support
* Install theme
	* Automatic activate
	* Batch install multiple themes
	* Install the theme in the local path (developing theme and official directory unregistered theme support)
* Install plugin
	* Automatic activate
	* Batch install multiple plugins
	* Install the plugin in the local path (developing plugin and official directory unregistered plugin support)
* Setting theme_mod (theme modification value) and Options
* Setting permalink structure
* Importing data from any one of 4 ways
	* WordPress export (WXR) file
	* SQL file (database dump data)
	* Backup plugin "BackWPup" archive file (Zip, Tar, Tar GZip, Tar BZip2)
	* Theme Unit Test
* Automatically place wp-content directory
* Automatically place uploads directory
* Replacement to the URL of the test environment from the URL of the production environment
* Regenerate thumbnails

### 3. Develop & Deploy Tools

Pre-installing PHP version managment 'phpenv', Dependency Manager for PHP 'Composer', command-line tools for WordPress 'WP-CLI' and version control system 'Git' in the standard.

You can install the develop tools or the deploy tools by usage. See Specification for list of installed tools.

## Requirements

* [Oracle VM VirtualBox](https://www.virtualbox.org) >= 5.2
* [Vagrant](https://www.vagrantup.com) >= 2.1
* [Ansible](https://www.ansible.com) >= 2.4

#### Vagrant plugin (optional)

* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
* [vagrant-serverspec](https://github.com/jvoorhis/vagrant-serverspec)

## Usage

### 1. Install Virtualbox

Download the VirtualBox form [www.virtualbox.org](https://www.virtualbox.org) and install.


### 2. Install Vagrant

Download the Vagrant form [www.vagrantup.com](https://www.vagrantup.com) and install.

### 3. Install Vagrant plugin

Install the Vagrant plugin on the terminal as necessary.

	vagrant plugin install vagrant-hostsupdater
	vagrant plugin install vagrant-vbguest
	vagrant plugin install vagrant-serverspec


### 4. Download Ansible playbooks of the VAW

Download a Vagrantfile and Ansible playbooks from the following link.

[Download Zip format file](https://github.com/thingsym/vaw/archive/master.zip)

### 5. Launch a virtual environment

	cd vaw-x.x.x
	vagrant up

If you don't have a Box at first, begins from the download of Box.
After provisioning, you can launch a WordPress development environment.

### 6. Access to the website and the WordPress Admin

Access to the website **http://vaw.local/**. Access to the WordPress admin **http://vaw.local/wp-admin/**.

## Default configuration Variables

ID and password for the initial setting is as follows. Can be set in the provisioning configuration file.

#### Database

* ROOT USER `root`
* ROOT PASSWORD `admin`
* HOST `localhost`
* DATABASE NAME `wordpress`
* USER `admin`
* PASSWORD `admin`

#### WordPress Admin

* USER `admin`
* PASSWORD `admin`

## Customize Options

You can build a variety of environment that edit configuration files of the VAW.

There are two configuration files you can customize.

* Vagrantfile
* group_vars/all.yml

Run `vagrant up` or `vagrant provision`, after editing the configuration files.

### Vagrant configuration file (Ruby)

Vagrant configuration file is **Vagrantfile**.

Vagrantfile will set the vagrant Box, private IP address, hostname and the document root.

If you launch multiple environments, change the name of the directory. Should rewrite `vm_ip` and `vm_hostname`. Note not to overlap with other environments.

You can accesse from a terminal in the same LAN to use the public network to Vagrant virtual environment. To use public networks, set IP address for bridged connection to `public_ip`. In that case, recommended that configure the same IP address to `vm_hostname`.

	## Vagrant Settings ##
	vm_box                = 'centos/7'
	vm_box_version        = '>= 0'
	vm_ip                 = '192.168.46.49'
	vm_hostname           = 'vaw.local'
	vm_document_root      = '/var/www/html'

	public_ip             = ''

	vbguest_auto_update   = true
	synced_folder_type    = 'virtualbox' # virtualbox|nfs|rsync|smb

	ansible_install_mode  = :default    # :default|:pip
	ansible_version       = 'latest'    # only :pip required

	provision_mode        = 'all'       # all|wordpress|box

* `vm_box` (required) name of Vagrant Box (default: `centos/7`)
* `vm_box_version` (required) version of Vagrant Box (default: `>= 0`)
* `vm_ip` (required) private IP address (default: `192.168.46.49`)
* `vm_hostname` (required) hostname (default: `vaw.local`)
* `vm_document_root` (required) document root path (default: `/var/www/html`)
	* auto create `wordpress` directory and synchronized
* `public_ip` IP address of bridged connection (default: `''`)
* `vbguest_auto_update` update VirtualBox Guest Additions (default: `true` / value: `true` | `false`)
* `synced_folder_type` the type of synced folder (default: `virtualbox` / value: `virtualbox` | `nfs` | `rsync` | `smb`)
* `ansible_install_mode` (required) the way to install Ansible (default: `:default` / value: `:default` | `:pip`)
* `ansible_version` version of Ansible to install (default: `latest`)
* `provision_mode` (required) Provisioning mode (default: `all` / value: `all` | `wordpress` | `box`)

### Provisioning configuration file (YAML)

Provisioning configuration file is **group_vars/all.yml**.

In YAML format, you can set server, database and WordPress environment. And can enable the develop and deploy tools.

	## Server & Database Settings ##

	server             : apache   # apache|nginx|h2o
	fastcgi            : none     # none|php-fpm|hhvm

	database           : mariadb  # mariadb|mysql|percona
	db_root_password   : admin

	db_host            : localhost
	db_name            : wordpress
	db_user            : admin
	db_password        : admin
	db_prefix          : wp_
	db_charset         : ''
	db_collate         : '' # utf8mb4_general_ci

	## WordPress Settings ##

	title              : VAW (Vagrant Ansible WordPress)
	admin_user         : admin
	admin_password     : admin
	admin_email        : hoge@example.com

	# e.g. latest, nightly, 4.1, 4.1-beta1
	# see Release Archive - https://wordpress.org/download/release-archive/
	# 3.7 or later to work properly
	version            : latest

	# e.g. en_US, ja, ...
	# see wordpress-i18n list - http://svn.automattic.com/wordpress-i18n/
	lang               : en_US

	# in own directory or subdirectory install.
	# see http://codex.wordpress.org/Giving_WordPress_Its_Own_Directory
	wp_dir             : ''   #e.g. /wordpress
	wp_site_path       : ''   #e.g. /wordpress

	multisite          : false   # true|false

	# default theme|slug|url|zip (local path, /vagrant/themes/*.zip)
	activate_theme     : ''
	themes             : []

	# slug|url|zip (local path, /vagrant/plugins/*.zip)
	activate_plugins   :
	                        - theme-check
	                        - log-deprecated-notices
	                        - debug-bar
	                        - query-monitor
	                        - broken-link-checker
	plugins            :
	                        - developer
	                        - monster-widget
	                        - wordpress-beta-tester
	                        - wp-multibyte-patch

	theme_mod          : {}

	# see Option Reference - http://codex.wordpress.org/Option_Reference
	options            : {}

	# e.g. /%year%/%monthnum%/%postname%
	# see http://codex.wordpress.org/Using_Permalinks
	permalink_structure  :
	                      structure   : ''
	                      category    : ''
	                      tag         : ''

	# Any one of 4 ways to import
	import_xml_data    : ''   # local path, /vagrant/import/*.xml
	import_db_data     : ''   # local path, /vagrant/import/*.sql
	import_backwpup    :
	                      path          : ''   # local path, /vagrant/import/*.zip
	                      db_data_file  : ''
	                      xml_data_file : ''
	import_admin       : false   # true|false
	theme_unit_test    : false   # true|false

	replace_old_url         : ''   # http(s)://example.com, to vm_hostname from old url
	regenerate_thumbnails   : false   # true|false

	WP_DEBUG           : true   # true|false
	SAVEQUERIES        : true   # true|false

	## Develop & Deploy Settings ##

	ssl                : false   # true|false

	# See Supported Versions http://php.net/supported-versions.php
	php_version        : 7.2.1
	http_protocol      : http   # http|https

	develop_tools      : false   # true|false
	deploy_tools       : false   # true|false

	## That's all, stop setting. Let's vagrant up!! ##

	WP_URL             : '{{ http_protocol }}://{{ HOSTNAME }}{{ wp_site_path }}'
	WP_PATH            : '{{ DOCUMENT_ROOT }}{{ wp_dir }}'


#### Server & Database Settings ##

* `server` (required) name of web server (default: `apache` / value: `apache` | `nginx` | `h2o`)
* `fastcgi` name of fastCGI (default: `none` / value: `none` | `php-fpm` | `hhvm`)
* `database` (required) name of databese (default: `mariadb` / value: `mariadb` | `mysql` | `percona`)
* `db_root_password` (required) database root password (default: `admin`)
* `db_host` (required) database host (default: `localhost`)
* `db_name` (required) name of database (default: `wordpress`)
* `db_user` (required) database user name (default: `admin`)
* `db_password` (required) database user password (default: `admin`)
* `db_prefix` database prefix (default: `wp_`)
* `db_charset` database character set (default: `''`)
* `db_collate` database collation (default: `''`)

#### WordPress Settings ##

* `title` WordPress site title (default: `VAW (Vagrant Ansible WordPress)`)
* `admin_user` (required) WordPress admin user name (default: `admin`)
* `admin_password` (required) WordPress admin user password (default: `admin`)
* `admin_email` (required) WordPress admin email address (default: `hoge@example.com`)
* `version` (required) version of WordPress (default: `latest`)
	* e.g. `latest`, `4.1`, `4.1-beta1`
	* see [Release Archive](https://wordpress.org/download/release-archive/)
	* version 3.7 or later to work properly
* `lang` (required) WordPress in your language (default: `en_US`)
	* e.g. `en_US`, `ja`, ...
	* see [wordpress-i18n list](http://svn.automattic.com/wordpress-i18n/)

* `wp_dir` directory path to subdirectory install WordPress (default: install to document root)
* `wp_site_path` path of site (default: document root)
	* If `wp_dir` and `wp_site_path` are the same path, in own directory install.
	* If `wp_dir` and `wp_site_path` are different path, install to subdirectory. Note that `wp_site_path` be placed on one above the directory than `wp_dir`.
	* see [Giving WordPress Its Own Directory](http://codex.wordpress.org/Giving_WordPress_Its_Own_Directory)

* `multisite` Multisite enabled flag (default: `false` / value: `true` | `false`)
* `activate_theme` install a theme and activated (default: default theme)
	* set default theme `''`, `theme slug`, `zip file URL` or  `local zip file path`
	* set `/vagrant/themes/*.zip` by local zip file path
* `themes` install themes
	* set in YAML arrays of hashes format `theme slug`, `zip file URL` or `local zip file path`
	* set `/vagrant/themes/*.zip` by local zip file path

Configuration example

	themes             :
	                     - yoko
	                     - Responsive

Disable the setting case

	themes             : []

* `activate_plugins` install plagins and activated
	* set in YAML arrays of hashes format `plagin slug`, `zip file URL` or `local zip file path`
	* set `/vagrant/plagins/*.zip` by local zip file path

Configuration example

	activate_plugins   :
	                        - theme-check
	                        - plugin-check

Disable the setting case

	activate_plugins   : []

* `plugins` install plagins
	* set in YAML arrays of hashes format `plagin slug`, `zip file URL` or `local zip file path`
	* set `/vagrant/plagins/*.zip` by local zip file path

* `theme_mod` setting theme_mod (theme modification value)
	* see [set_theme_mod()](http://codex.wordpress.org/Function_Reference/set_theme_mod)
	* set in YAML nested hash format

Configuration example

	theme_mod          :
	                       background_color: 'cccccc'

Disable the setting case

	theme_mod          : {}

* `options` setting options
	* see [update_option()](http://codex.wordpress.org/Function_Reference/update_option) and [Option Reference](http://codex.wordpress.org/Option_Reference)
	* set in YAML nested hash format

Configuration example

	options            :
	                       blogname: 'blog title'
	                       blogdescription: 'blog description'

Disable the setting case

	options            : {}

* `permalink_structure` setting permalink structure
	* set the following three permalink structures
	* see [Using Permalinks](http://codex.wordpress.org/Using_Permalinks)
	* `structure` set the permalink structure using the structure tags
	* `category` set the prefix of the category archive
	* `tag` set the prefix of the tag archive
* `import_xml_data` local WordPress export (WXR) file path `/vagrant/import/*.xml`
* `import_db_data` local sql dump file path `/vagrant/import/*.sql`
* `import_backwpup`
	* `path` Archive file path `/vagrant/import/*.zip` (Zip, Tar, Tar GZip, Tar BZip2)
	* `db_data_file` DB backup file name (Import from one of data files)
	* `xml_data_file` XML export file name (imported from one of the data files)
* `import_admin` Add WordPress administrator user (default: `false` / value: `true` | `false`)
* `theme_unit_test` import Theme Unit Test data enabled flag (default: `false` / value: `true` | `false`)
* `replace_old_url` replace to `vm_hostname` from `old url`
* `regenerate_thumbnails` regenerate thumbnails enabled flag (default: `false` / value: `true` | `false`)
* `WP_DEBUG` debug mode (default: `true` / value: `true` | `false`)
* `SAVEQUERIES` save the database queries (default: `true` / value: `true` | `false`)

#### Develop & Deploy Settings ##

* `ssl` WordPress administration over SSL enabled flag (default: `false` / value: `true` | `false`)
* `php_version` version of PHP (default: `7.2.1`)
* `http_protocol` HTTP protocol (default: `http` / value: `http` | `https`)
* `develop_tools` activate develop tools (default: `false` / value: `true` | `false`)
* `deploy_tools` activate deploy tools (default: `false` / value: `true` | `false`)

## Directory Layout

Directory structure of the VAW is as follows.

This directory synchronize to the guest OS side `/vagrant`. `wordpress` creates automatically and synchronize to `vm_document_root`.

`wp-content` is a directory that stores WordPress themes, plugins, and upload files. `wp-content` will be placed automatically in WordPress which was built at the time of provisioning, if you place `wp-content` in this directory from the production environment.

`uploads` is a directory where stored upload files in `wp-content` directory of WordPress. `uploads` will be placed automatically in WordPress which was built at the time of provisioning, if you place `uploads` in this directory from the production environment.

You can create the same environment as the production environment, when you build a wordpress by import database dump data, substitution of url, regeneration of thumbnail image. You can set all from the provisioning configuration file.

### Full Layout

* backup (stores backup file. create automatically at running script, if it does not exist.)
* command (stores shell script)
* config (stores Custom Config)
* config.sample (sample Custom Config)
* group_vars (stores the provisioning configuration file of Ansible)
	* all.yml (provisioning configuration file)
* hosts
	* local (inventory file)
* import (stores import data, if necessary)
* LICENSE (license file)
* plugins (stores WordPress plugin zip format files, if necessary)
* Rakefile (Rakefile of ServerSpec)
* README-ja.md
* README.md
* roles (stores Ansible playbook of each role)
* site.yml (Ansible playbook core file)
* spec (stores ServerSpec spec file)
	* box
	* localhost
	* spec_helper.rb
	* sync-dir
* themes (stores WordPress theme zip format files, if necessary)
* uploads (uploads directory in the wp-content)
* Vagrantfile (Vagrant configuration file)
* wordpress (synchronize to the Document Root. create automatically at `vagrant up`, if it does not exist.)
* wp-content (WordPress's wp-content directory)

### Minimum Layout

The VAW will be built in the directory structure of the following minimum unit.

* group_vars (stores the provisioning configuration file of Ansible)
	* all.yml (provisioning configuration file)
* hosts
	* local (inventory file)
* roles (stores Ansible playbook of each role)
* site.yml (Ansible playbook core file)
* Vagrantfile (Vagrant configuration file)
* wordpress (synchronize to the Document Root. create automatically at `vagrant up`, if it does not exist.)


## Vagrant Box

The VAW supports VirtualBox for providers of Vagrant.
Operating system and architecture supported centos-7.x x86_64 and centos-6.x x86_64 Vagrant Box. To download Vagrant Box, you can search from [Discover Vagrant Boxes](https://app.vagrantup.com/boxes/search?provider=virtualbox).

By default, the Vagrantfile uses the `vaw/centos*-default` Box which has already provisioned default settings.

In addition, you can use the `vaw/centos*-full` Box which has already provisioned default settings and activate develop and deploy tools.

You can build the environment in a short period of time compared with provisioning from the pure vagrant Box.

### CentOS 7

* [vaw/centos7-default](https://atlas.hashicorp.com/vaw/boxes/centos7-default)
* [vaw/centos7-full](https://atlas.hashicorp.com/vaw/boxes/centos7-full)

### CentOS 6

* [vaw/centos6-default](https://atlas.hashicorp.com/vaw/boxes/centos6-default)
* [vaw/centos6-full](https://atlas.hashicorp.com/vaw/boxes/centos6-full)

## Provisioning mode

The VAW has three provisioning modes.

* `all` will normal provisioning from the pure Vagrant Box.
* `wordpress` provisions only sync folders including WordPress.
* `box` provision to create a Vagrant Box.

The VAW is characterized by being able to provision with various server and database configuration combinations. On the other hand, it takes time to build the environment from pure Vagrant Box.

You can create a Vagrant Box with server and database configuration in advance. By using the created Vagrant Box you can shorten the provisioning time.

First, create a Vagrant Box with Provision mode `box`.
Next, provision the created Vagrant Box with Provision mode `wordpress`.
Based on the Vagrant Box you created, WordPress development environment will start quickly anytime.

## How to make Vagrant Box

How to use the provisioning mode?

Let's see how to make Vagrant Box through the process from provisioning with Vagrant Box to building WordPress development environment.

### 1. Setting of configuration file

We will launch the Vagrant environment for creating Vagrant Box.
First of all, Set up the Vagrant configuration file and the provisioning configuration file.

Set `provision_mode` in the Vagrant configuration file to `box`.

	provision_mode        = 'box'    # all|wordpress|box

You can set the provisioning configuration file as you like.

However, if `provision_mode` is `box`, the WordPress Settings section of the provisioning configuration file will be skipped during provisioning.

### 2. Provisioning

Provision and build the environment.

	vagrant up

### 3. Creating a Vagrant Box (Packaging)

After provisioning is completed, create a Vagrant Box with a box name. (e.g. sample.box)

	vagrant package --output sample.box

### 4. Registration of Vagrant Box

Add the created Vagrant Box to Vagrant. (Register as eg sample)

	vagrant box add sample.box --name sample

You can delete the Vagrant Box file created for creating Vagrant Box. (e.g. sample.box)
You can destroy the launched Vagrant environment after checking the operation.

	vagrant destroy

### 5. Provisioning with the created Vagrant Box

Launch the Vagrant environment for WordPress development with the Vagrant Box you created.
Set up the Vagrant configuration file and the provisioning configuration file.

Set `vm_box` of the Vagrant configuration file to `sample`. (e.g. sample)
Set `provision_mode` in the Vagrant configuration file to `wordpress`.

	vm_box                = 'sample'
	...
	provision_mode        = 'wordpress'    # all|wordpress|box

You can set the provisioning configuration file as you like.

However, if `provision_mode` is `wordpress`, only the WordPress Settings section of the provisioning configuration file is enabled during provisioning.

### 6. Launch a virtual environment

	vagrant up

After provisioning, you can launch a WordPress development environment.

## Specification

### Server (Selectable)

* [Apache](http://httpd.apache.org)
* [nginx](http://nginx.org)
* [H2O](https://h2o.examp1e.net)

### FastCGI (Selectable)

* [PHP-FPM](http://php-fpm.org) (FastCGI Process Manager)
* [HHVM](http://hhvm.com) (HipHop Virtual Machine)

### Database (Selectable)

* [MariaDB](https://mariadb.org)
* [MySQL](http://www.mysql.com)
* [Percona MySQL](http://www.percona.com/software/percona-server)

### Pre-installing

* [WordPress](https://wordpress.org)
* [phpenv](https://github.com/CHH/phpenv)
* [php-build](https://php-build.github.io)
* [PHP](https://secure.php.net) (Zend OPcache, APCu) via [phpenv](https://github.com/CHH/phpenv)
* [Composer](https://getcomposer.org/) via [phpenv](https://github.com/CHH/phpenv)
* [OpenSSL](https://www.openssl.org) (Selectable)
* [WP-CLI](http://wp-cli.org)
* [Git](http://git-scm.com)

### Develop Tools (Activatable)

* [Subversion](https://subversion.apache.org)
* [gettext](https://www.gnu.org/software/gettext/)
* [nodenv](https://github.com/nodenv/nodenv)
* [Node.js](http://nodejs.org) via [nodenv](https://github.com/nodenv/nodenv)
* [npm](https://www.npmjs.com)
* [Yarn](https://yarnpkg.com/)
* [Grunt](http://gruntjs.com)
* [gulp](http://gulpjs.com)
* [WordPress i18n tools](http://codex.wordpress.org/I18n_for_WordPress_Developers)
* [Xdebug](http://xdebug.org)
* [PHPUnit](https://phpunit.de)
* [PHPUnit Selenium](https://github.com/giorgiosironi/phpunit-selenium)
* [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) & [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards)
* Opcache Web Viewer ([Opcache-Status](https://github.com/rlerdorf/opcache-status), [opcache-gui](https://github.com/amnuts/opcache-gui), [ocp.php](https://gist.github.com/ck-on/4959032/))
* [cachetool](http://gordalina.github.io/cachetool/)
* [wrk - Modern HTTP benchmarking tool](https://github.com/wg/wrk)
* [plato](https://github.com/es-analysis/plato)
* [stylestats](https://github.com/t32k/stylestats)
* [PHPMD](https://phpmd.org/)
* [webgrind](https://github.com/jokkedk/webgrind)
* [MailHog](https://github.com/mailhog/MailHog)

### Deploy Tools (Activatable)

* [Dandelion](http://scttnlsn.github.io/dandelion/)
* [Deployer](https://deployer.org/)
* [Git-ftp](https://git-ftp.github.io/)
* [Wordmove](https://github.com/welaika/wordmove)

### Other

* [rbenv](https://github.com/sstephenson/rbenv)
* [ruby-build](https://github.com/sstephenson/ruby-build)
* [Ruby](https://www.ruby-lang.org/) via [rbenv](https://github.com/sstephenson/rbenv)


### Helper command

* after_provision.sh
* before_provision.sh
* centos-box.sh
* db_backup.sh
* phpenv.sh

## Helper command

The **VAW** offers a useful scripts. Just run the script on a terminal. Database data backup, multiple versions installation of PHP, you can switch the execution environment.

### db_backup.sh

`db_backup.sh` will back up the database. Save at `backup-%Y%m%d%H%M%S.sql` format in the `backup` folder.

	cd /var/www/html
	/vagrant/command/db_backup.sh

### phpenv.sh

`phpenv.sh` will prepare the specified version of PHP execution environment. You can install the specified version of PHP. Switching the PHP version. And then restart Apache or PHP-FPM by switching the server configuration environment.

	/vagrant/command/phpenv.sh -v 7.2.1 -m php-fpm -s unix

	# help
	/vagrant/command/phpenv.sh -h

## Custom Config

When you add a tuning configuration file that you edited in the directory `config`, place it at the time of provisioning.
As follows editable configuration files.

* default-node-packages.j2
* default-ruby-gems.j2
* h2o.conf.j2
* hhvm.server.ini.j2
* httpd.conf.centos6.j2
* httpd.conf.centos7.j2
* httpd.www.conf.centos7.j2
* mariadb.my.cnf.j2
* mysql.my.cnf.j2
* nginx.conf.j2
* nginx.multisite.conf.j2
* nginx.wordpress.conf.j2
* nginx.wordpress.multisite.conf.j2
* percona.my.cnf.j2
* php-build.default_configure_options.j2
* ssh-config.j2

## Contribution

### Patches and Bug Fixes

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

1. Fork [VAW](https://github.com/thingsym/vaw) from GitHub repository
2. Create a feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Create new Pull Request

## Changelog

* version 0.5.8 - 2018.05.27
	* add deployer and git-ftp
	* remove capistrano and fabric
	* add handlers with web server
	* add option synced_folder_type with Vagrant Settings
* version 0.5.7 - 2018.05.13
	* change module from command to gem/npm
	* fix deprecated match filter
	* remove mount_options
	* fix vbguest_auto_update
	* change official Vagrant box to official distributor
	* change from yum claen all to yum makecache fast, only CentOS6
	* fix default PHP version to 7.2.1
	* fix defaults with wordpress task
	* remove defaults with wp-cli task
	* remove themes, plugins and import directories
	* fix reset database tasks
	* revert SELinux with CentOS7
	* remove swap space
	* fix *env path
	* using 'become' and 'become_user' rather than running sudo
	* add .bashrc_vaw
	* remove bash settings into .bash_profile, integrate into .bashrc
	* move documentation from docs to gh-pages branch
* version 0.5.6 - 2018.03.25
	* update vm_box
	* add type option into config.vm.synced_folder
	* bump up PHP version to 7.2.1
	* fix mailhog handlers
	* bump up daemonize version to 1.7.8
	* improve daemonize installation
	* remove CityFan repo
	* add Exit Code into command
	* add chrony with centos 7
	* improve phpenv.sh version 0.1.2 for CentOS
	* add mod_ssl
	* change setting name from ssl_wp_admin to ssl
	* fix ssl path
	* fix self Certification Authority
	* fix ruby build env
	* remove rbenv-gem-rehash
	* fix bundler via rbenv-default-gems
	* change multiple conditions of the when statement to as a list
	* change readme file name to upper case
* version 0.5.5 - 2017.12.05
	* add documentation
* version 0.5.4 - 2017.11.19
	* fix comment
	* add WordPress plugin
	* update theme-unit-test
	* fix AllowOverride in httpd.conf for security plugins
	* add default-character-set utf8mb4 with client section
* version 0.5.3 - 2017.10.03
	* fix comment
	* change database charset from utf8 to utf8mb4
	* add MailHog
* version 0.5.2 - 2017.08.17
	* bump up PHP version to 7.1.7
	* fix phpenv.sh
	* change setting name from ssl_admin to ssl_wp_admin
	* enable sync-dir with before-command and after-command
	* fixed version with PHPUnit, PHP_CodeSniffer and PHPUnit Selenium
	* change label of provision_mode from normal to all
	* change order of setting items
	* fix settings format
	* add .travis.yml
	* fix vb.customize for improve VirutalBox performance
	* remove vagrant-cachier plugin
* version 0.5.1 - 2017.07.12
	* fix php-cgi not found
	* fix webserver and fastcgi owner/group
	* remove bower
	* add tests for box
	* fix centos-box.sh
	* change provision_only_wordpress mode to provision_mode
	* rename certificate file and key
	* fix libcurl installation
* version 0.5.0 - 2017.06.20
	* fix centos-box.sh
	* fix vm_box, using public Vagrant boxes
	* add CityFan repository for libcurl, only CentOS 6
	* set permission to synced_folder wordpress
	* change default database to mariadb from mysql
	* fix server test
	* fix php install via phpenv.sh
	* add socket argument to phpenv.sh
	* add fastcgi to apache
	* improve phpenv.sh version 0.1.1 for CentOS
	* add forwarded_port for Browsersync
	* fix php post_max_size to 32M
	* remove wp-phpcs ruleset
	* add custom hhvm.server.ini
	* bump up Ruby version to 2.4.1
	* add webserver h2o
	* change hhvm fastcgi connect to UNIX domain socket from TCP
	* change webserver and fastcgi owner/group nobody
	* add my.cnf for each database
	* fix opcache disable
	* add tests for sync-dir
	* update activate plugins
	* add wordpress import for backwpup
	* add wp-content automatic place
	* fix sendfile off
* version 0.4.4 - 2017.03.18
	* using YAML dictionaries in tasks
	* add centos-box.sh
* version 0.4.3 - 2017.03.07
	* add custom ~/.ssh/config
	* add only WordPress provision mode
	* add ansible install_mode
	* fix hhvm
	* change filename extension from cert to crt
	* add packagist.jp repository
	* fix wp core config parameter
	* add yarn
	* add cachetool
	* fix mysql and mariadb tasks
	* add yum-utils
	* fix database tests
	* update percona-release-0.1-4.noarch.rpm
	* fix my.cnf.j2
	* fix httpd.conf when ssl enable
	* add tests of wordpress
	* replace from shell module to command module
	* provision fail only when SELinux is Enforcing
	* fix dest path of default_configure_options
	* fix php.conf.j2
	* bump up node version to 6.9.1
	* fix default-node-packages.j2
* version 0.4.2 - 2016.10.04
	* add develop-tools role, fix build environment
	* fix the inline script to get the major version number
	* fix sudo user
	* fix shebang
* version 0.4.1 - 2016.09.10
	* fix inline shell in Vagrantfile
	* fix nodejs version
* version 0.4.0 - 2016.08.22
	* bump up php version to 7.0.7
	* change to package module from yum module
	* change default box to CentOS 7 from CentOS 6
	* add synced_folder /vagrant
	* add vagrant-vbguest
	* change to yum_repository module from template module
	* fix home_dir path into playbooks
	* add phpenv-composer, remove composer role
	* fix phpenv role
	* add nodenv role, remove nodejs, npm
	* change provision to ansible_local from inline shell
	* remove RepoForge repository
	* add webgrind
	* add phpmd
	* add prestissimo
	* fix re2c via yum
	* fix tests
	* add gulp-cli and npm-check-updates, remove gulp globally
	* change to become, since sudo has been deprecated
	* fix phpenv.sh
* version 0.3.3 - 2016.05.31
	* fix playbooks
	* remove compass gem
	* refactoring phpenv.sh
	* disable OPcache
* version 0.3.2 - 2016.02.09
	* add custom config
	* remove server tuning
* version 0.3.1 - 2016.01.18
	* fix yum releasever version
* version 0.3.0 - 2015.12.21
	* fix Vagrantfile
	* fix wp-cli role, compatible with WordPress 4.4
	* improve hhvm role
	* improve command phpenv.sh
	* support CentOS 7 x86-64
* version 0.2.1 - 2015.10.09
	* add stylestats
	* add plato
* version 0.2.0 - 2015.08.31
	* fix Fabric
	* fix WordPress plugins
	* fix rbenv and hhvm, MariaDB roles
	* fix memory 1.5GB
	* remove php55 and php-fpm roles
	* add command phpenv.sh
	* add phpenv role, replaced from php
* version 0.1.8 - 2015.08.04
	* fix WordPress plugins
	* add PHPUnit Selenium
* version 0.1.7 - 2015.07.06
	* add public_network
* version 0.1.6 - 2015.06.15
	* add vm_box_version
* version 0.1.5 - 2015.06.04
	* add Fabric
	* add wrk
	* add command db_backup.sh
	* nginx tuning
* version 0.1.4 - 2015.04.29
	* fix Ansible 1.9.x
* version 0.1.3 - 2015.02.17
	* fix fastcgi_spec.rb
* version 0.1.2 - 2015.01.31
	* change how to set the environment variables to .bash_profile
	* fix Vagrantfile
* version 0.1.1 - 2015.01.14
	* change setting format
	* fix yum repository metadata
	* add WordPress options
	* add sass and compass gems
	* fix wp-cli role
* version 0.1.0 - 2014.12.22
	* initial release

## License

The VAW is distributed under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html).

## Author

[thingsym](https://github.com/thingsym)

Copyright (c) 2014-2018 thingsym
