# VAW (Vagrant Ansible WordPress)

The **VAW (Vagrant Ansible WordPress)** is **Ansible playbooks** for website developer, designer, webmaster and WordPress theme/plugin developer.

Launch the development environment in Vagrant, you can build the website and verify the operation of the website. Of course, you can also develop WordPress themes and plugins.

The **VAW** is also a collaboration tool. You can take advantage of collaboration tool that share the environment with development partners, designers and clients.

VAW (Vagrant Ansible WordPress) documentation: [https://thingsym.github.io/vaw/](https://thingsym.github.io/vaw/)

## Features

### 1. Build OS, Server and Database environment

The **VAW** will build OS from **CentOS** or **Debian** or **Ubuntu**, server from **Apache** or **nginx** or **H2O**, and build database from **MariaDB** or **MySQL**.

On all web servers, FastCGI configuration is possible. Build PHP execution environment from **PHP-FPM** (FastCGI Process Manager).

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

* [Oracle VM VirtualBox](https://www.virtualbox.org) >= 6.1
* [Vagrant](https://www.vagrantup.com) >= 2.2
* [Ansible](https://www.ansible.com) >= 2.9

#### Optional

* [mkcert](https://github.com/FiloSottile/mkcert)

### Vagrant plugin (optional)

* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
* [vagrant-serverspec](https://github.com/jvoorhis/vagrant-serverspec)

## Usage

### 1. Install Virtualbox

Download the VirtualBox form [www.virtualbox.org](https://www.virtualbox.org) and install.


### 2. Install Vagrant

Download the Vagrant form [www.vagrantup.com](https://www.vagrantup.com) and install.

### 3. Download Ansible playbooks of the VAW

Download a Vagrantfile and Ansible playbooks from the following link.

[Releases page](https://github.com/thingsym/vaw/releases)

### 4. Generate SSL certificate files using mkcert

Install mkcert. See [https://github.com/FiloSottile/mkcert](https://github.com/FiloSottile/mkcert)

	cd vaw-x.x.x
	mkcert -install
	mkdir mkcert
	mkcert -cert-file ./mkcert/cert.pem -key-file ./mkcert/privkey.pem <vm_hostname>

### 5. Launch a virtual environment

	cd vaw-x.x.x
	vagrant up

If you don't have a Box at first, begins from the download of Box.
After provisioning, you can launch a WordPress development environment.

Note: Passwordless for Vagrant::Hostsupdater. See [Suppressing prompts for elevating privileges
](https://github.com/agiledivider/vagrant-hostsupdater#suppressing-prompts-for-elevating-privileges)

### 6. Access to the website and the WordPress Admin

Access to the website **http://vaw.local/**. Access to the WordPress admin **http://vaw.local/wp-admin/**.

### 7. Access to a Vagrant machine via SSH

	vagrant ssh

Or using ssh config.

	vagrant ssh-config > ssh_config.cache
	ssh -F ssh_config.cache default

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

	vm_box                = 'debian/bullseye64'    # Debian 11.0
	vm_box_version        = '>= 0'
	vm_ip                 = '192.168.46.49'
	vm_hostname           = 'vaw.local'
	vm_document_root      = '/var/www/html'

	public_ip             = ''

	forwarded_port        = [
		3000,
		3001,
		1025,
		8025
	]

	vbguest_auto_update   = true
	synced_folder_type    = 'virtualbox' # virtualbox|nfs|rsync|smb

	backup_database       = false

	ansible_install       = true
	ansible_install_mode  = :default    # :default|:pip
	ansible_version       = 'latest'    # requires :pip in ansible_install_mode


	provision_mode        = 'all'       # all|wordpress|box

	vagrant_plugins       = [
		'vagrant-hostsupdater',
		'vagrant-vbguest',
		'vagrant-serverspec'
	]

* `vm_box` (required) name of Vagrant Box (default: `debian/bullseye64`)
* `vm_box_version` (required) version of Vagrant Box (default: `>= 0`)
* `vm_ip` (required) private IP address (default: `192.168.46.49`)
* `vm_hostname` (required) hostname (default: `vaw.local`)
* `vm_document_root` (required) document root path (default: `/var/www/html`)
	* auto create `wordpress` directory and synchronized
* `public_ip` IP address of bridged connection (default: `''`)
* `forwarded_port` list of ports that you want to transfer (default: `[ 3000, 3001, 1025, 8025 ]`)
	* 3000: Browsersync auto-detected port
	* 3001: Browsersync ui port
	* 1025: MailHog SMTP default port
	* 8025: MailHog HTTP default port
* `vbguest_auto_update` whether to update VirtualBox Guest Additions (default: `true` / value: `true` | `false`)
トします (default: `true` / value: `true` | `false`)
* `synced_folder_type` the type of synced folder (default: `virtualbox` / value: `virtualbox` | `nfs` | `rsync` | `smb`)
* `backup_database` enable auto database backup when vagrant destroy or halt (default: `false` / value: `true` | `false`)
* `ansible_install` (required) install Ansible (default: `:true` / value: `:true` | `:false`)
* `ansible_install_mode` (required) the way to install Ansible (default: `:default` / value: `:default` | `:pip`)
* `ansible_version` version of Ansible to install (default: `latest`)
* `provision_mode` (required) Provisioning mode (default: `all` / value: `all` | `wordpress` | `box`)
* `vagrant_plugins` install vagrant plugins

### Provisioning configuration file (YAML)

Provisioning configuration file is **group_vars/all.yml**.

In YAML format, you can set server, database and WordPress environment. And can enable the develop and deploy tools.

	## Server & Database Settings ##

	server             : apache   # apache|nginx|h2o
	fastcgi            : none     # none|php-fpm

	database           : mariadb  # mariadb|mysql
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

	replace_old_url         : [] # http(s)://example.com, to vm_hostname from old url
	search_replace_strings  : {}
	regenerate_thumbnails   : false   # true|false

	WP_DEBUG           : true   # true|false
	SAVEQUERIES        : true   # true|false

	## Develop & Deploy Settings ##

	ssl                : true   # true|false
	http_protocol      : https   # http|https

	# See Supported Versions http://php.net/supported-versions.php
	php_version        : 7.4.33

	develop_tools      : false   # true|false
	deploy_tools       : false   # true|false

	## That's all, stop setting. Let's vagrant up!! ##

	WP_URL             : '{{ http_protocol }}://{{ HOSTNAME }}{{ wp_site_path }}'
	WP_PATH            : '{{ DOCUMENT_ROOT }}{{ wp_dir }}'


#### Server & Database Settings ##

* `server` (required) name of web server (default: `apache` / value: `apache` | `nginx` | `h2o`)
* `fastcgi` name of fastCGI (default: `none` / value: `none` | `php-fpm`)
* `database` (required) name of databese (default: `mariadb` / value: `mariadb` | `mysql`)
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

Configuration example

	replace_old_url         :
	                           - http://example.com
	                           - http://www.example.com
	                           - https://example.com

Disable the setting case

	replace_old_url         : []

* `search_replace_strings` Search the database and replace the matched string

Configuration example

	search_replace_strings  :
	                           'foo': 'bar'
	                           'abc': 'xyz'
	                           'Hello, World!': 'Welcome to WordPress!'

Disable the setting case

	search_replace_strings  : {}

* `regenerate_thumbnails` regenerate thumbnails enabled flag (default: `false` / value: `true` | `false`)
* `WP_DEBUG` debug mode (default: `true` / value: `true` | `false`)
* `SAVEQUERIES` save the database queries (default: `true` / value: `true` | `false`)

#### Develop & Deploy Settings ##

* `ssl` WordPress administration over SSL enabled flag (default: `true` / value: `true` | `false`)
* `http_protocol` HTTP protocol (default: `https` / value: `http` | `https`)
* `php_version` version of PHP (default: `7.4.33`)
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
* mkcert (stores SSL certificate files)
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

The VAW supports VirtualBox for providers of Vagrant. Operating system supported CentOS, Debian and Ubuntu Boxes. OS architecture supported x86_64. Details are as follows:

### Debian

* Debian 12.0
* Debian 11.0
* Debian 10.0 (Deprecated ended 2024-06-30)
* Debian 9.0 (Deprecated ended 2022-06-30)
* Debian 8.0 (Deprecated ended 2020-06-30)

### Ubuntu

* Ubuntu 20.04
* Ubuntu 18.04
* Ubuntu 16.04
* Ubuntu 14.04

### CentOS

* CentOS 8 (Deprecated ended 2021-12-31)
* CentOS 7 (Deprecated ended 2024-06-30)
* CentOS 6 (Deprecated ended 2020-11-30)

To download Vagrant Box, you can search from [Discover Vagrant Boxes](https://app.vagrantup.com/boxes/search?provider=virtualbox).

**Note: The `vaw/centos*-default` and `vaw/centos*-full` Boxs has been deprecated. From now on, we recommend using the distribution box.**

By default, the Vagrantfile uses the `vaw/centos*-default` Box which has already provisioned default settings.

In addition, you can use the `vaw/centos*-full` Box which has already provisioned default settings and activate develop and deploy tools.

You can build the environment in a short period of time compared with provisioning from the pure vagrant Box.

### CentOS 7 (Deprecated)

* [vaw/centos7-default](https://atlas.hashicorp.com/vaw/boxes/centos7-default)
* [vaw/centos7-full](https://atlas.hashicorp.com/vaw/boxes/centos7-full)

### CentOS 6 (Deprecated)

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

### Database (Selectable)

* [MariaDB](https://mariadb.org)
* [MySQL](http://www.mysql.com)

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
* [npm-check-updates](https://www.npmjs.com/package/npm-check-updates)
* [Xdebug](http://xdebug.org)
* Opcache Web Viewer ([Opcache-Status](https://github.com/rlerdorf/opcache-status), [opcache-gui](https://github.com/amnuts/opcache-gui), [ocp.php](https://gist.github.com/ck-on/4959032/))
* [cachetool](http://gordalina.github.io/cachetool/)
* [wrk - Modern HTTP benchmarking tool](https://github.com/wg/wrk)
* [webgrind](https://github.com/jokkedk/webgrind)
* [MailHog](https://github.com/mailhog/MailHog)

### Deploy Tools (Activatable)

* [Dandelion](http://scttnlsn.github.io/dandelion/)
* [Wordmove](https://github.com/welaika/wordmove)

### Other

* [rbenv](https://github.com/sstephenson/rbenv)
* [ruby-build](https://github.com/sstephenson/ruby-build)
* [Ruby](https://www.ruby-lang.org/) via [rbenv](https://github.com/sstephenson/rbenv)

### Deprecated Tools (Recommend migrating to project's local development environment)

We recommend that you use package.json or composer.json to migrate to your project's local development environment.

#### Migrate to package.json

* [plato](https://github.com/es-analysis/plato)
* [stylestats](https://github.com/t32k/stylestats)

#### Migrate to composer.json

* [PHPUnit](https://phpunit.de)
* [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) & [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards)
* [PHPStan](https://github.com/phpstan/phpstan) (Only PHP7)
* [PHPMD](https://phpmd.org/)
* [PHPUnit Selenium](https://github.com/giorgiosironi/phpunit-selenium)

### Helper command

* after_provision.sh
* before_provision.sh
* centos-box.sh
* db_backup.sh
* npm-installer.sh
* phpenv.sh

## Helper command

The **VAW** offers a useful scripts. Just run the script on a terminal. Database data backup, multiple versions installation of PHP, you can switch the execution environment.

### db_backup.sh

`db_backup.sh` will back up the database. Save at `backup-%Y%m%d%H%M%S.sql` format in the `backup` folder.

	cd /var/www/html
	/vagrant/command/db_backup.sh

### phpenv.sh

`phpenv.sh` will prepare the specified version of PHP execution environment. You can install the specified version of PHP. Switching the PHP version. And then restart Apache or PHP-FPM by switching the server configuration environment.

	/vagrant/command/phpenv.sh -v 8.2.19 -m php-fpm -s unix

	# help
	/vagrant/command/phpenv.sh -h

## Custom Config

When you add a tuning configuration file that you edited in the directory `config`, place it at the time of provisioning.
As follows editable configuration files.

* default-node-packages.j2
* default-ruby-gems.j2
* h2o.conf.j2
* httpd.conf.centos6.j2
* httpd.conf.centos7.j2
* httpd.www.conf.centos7.j2
* mariadb.my.cnf.j2
* mysql.my.cnf.j2
* nginx.conf.j2
* nginx.multisite.conf.j2
* nginx.wordpress.conf.j2
* nginx.wordpress.multisite.conf.j2
* php-build.default_configure_options.j2
* php-fpm.conf (for phpenv.sh)
* php-fpm.www.conf (for phpenv.sh)
* php.ini (for phpenv.sh)
* ssh-config.j2

## Trouble shooting

### Vagrant can't mount to /mnt when vagrant up.

The following `umount /mnt` error message is displayed.

```
The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!

umount /mnt

Stdout from the command:


Stderr from the command:

umount: /mnt: not mounted
```

It may happens if the kernel version of OS used in vagrant box does not match the requirements.

The solution is to update the kernel and provision again. It may also be resolved by updating the vagrant box.

1. Access to a guest via SSH.

```
vagrant ssh
```

2. Update the kernel into guest.

#### Debian or Ubuntu

```
sudo apt-get -y install linux-image-amd64 linux-headers-amd64
```

#### CentOS

```
sudo yum -y update kernel kernel-devel kernel-headers kernel-tools kernel-tools-libs

exit
```

3. Provision again on the host.

```
vagrant reload
```

## Contribution

### Patches and Bug Fixes

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

1. Fork [VAW](https://github.com/thingsym/vaw) from GitHub repository
2. Create a feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Create new Pull Request

## Changelog

See CHANGELOG.md

## License

The VAW is distributed under [GPLv3](https://www.gnu.org/licenses/gpl-3.0.html).

## Author

[thingsym](https://github.com/thingsym)

Copyright (c) 2014-2021 thingsym
