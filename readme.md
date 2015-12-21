# VAW (Vagrant Ansible WordPress)

**VAW (Vagrant Ansible WordPress)** is Ansible playbooks for website developer, webmaster and WordPress theme/plugin developer.

Launch the development environment in Vagrant, you can build the website and verify the operation of the website. Of course, you can also develop WordPress themes and plugins.

**VAW** is also a collaboration tool. You can take advantage of collaboration tool that share the environment with development partners, designers and client.

## Features

### 1. Build Server and Database environment

**VAW** will build server from **Apache** or **nginx**, and build database from **MySQL**, **MariaDB** or **Percona MySQL**.

Server nginx is a FastCGI configuration as a reverse proxy. And building a PHP execution environment from **PHP-FPM** (FastCGI Process Manager) or **HHVM** (HipHop Virtual Machine).

By default, the server is installed in the default settings. Also can be installed in the tuned configuration.

You can validate on the server and database of various combinations.

### 2. Build WordPress environment

**VAW** will build a WordPress which has been processed in a variety of settings and data.

You can verify the test data or real data on WordPress. VAW will realize building of WordPress synchronized with the data and files in the production environment.

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
* Importing data from any one of three ways
	* WordPress export (WXR) file
	* SQL file (database dump data)
	* Theme Unit Test
* Automatic placement to wp-content of uploads directory
* Replacement to the URL of the test environment from the URL of the production environment
* Regenerate thumbnails

### 3. Develop & Deploy Tools

Pre-installing PHP version managment 'phpenv', Dependency Manager for PHP 'Composer', command-line tools for WordPress 'WP-CLI' and version control system 'Git' in the standard.

You can install the develop tools or the deploy tools by usage. See Specification for list of installed tools.

## Requirements

* [Virtualbox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com) >= 1.7.1 (Box centos-6.x x86_64)
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) *optional (Vagrant plugin)
* [vagrant-cachier](http://fgrehm.viewdocs.io/vagrant-cachier) *optional (Vagrant plugin)
* [vagrant-serverspec](https://github.com/jvoorhis/vagrant-serverspec) *optional (Vagrant plugin)


## Usage

### 1. Install Virtualbox

Download the VirtualBox form [www.virtualbox.org](https://www.virtualbox.org) and install.


### 2. Install Vagrant

Download the Vagrant form [www.vagrantup.com](https://www.vagrantup.com) and install.

### 3. Install Vagrant plugin

Install the Vagrant plugin on the terminal as necessary.

	vagrant plugin install vagrant-hostsupdater
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-serverspec


### 4. Download Ansible playbooks of VAW

Download a Vagrantfile and Ansible playbooks from the following link.

[Download Zip format file](https://github.com/thingsym/vaw/archive/master.zip)

### 5. Launch a virtual environment

	cd vaw-x.x.x
	vagrant up

If you don't have a Box at first, begins from the download of Box. After provisioning, you can launch a WordPress environment.

### 6. Access to the website and the WordPress Admin

Access to the website **http://vaw.local/**. Access to the WordPress admin **http://vaw.local/wp-admin/**.

## Default configuration Variables

ID and password for the initial setting is as follows. Can be set in the provisioning configuration file.

#### Database

* ROOT PASSWORD `admin`
* HOST `localhost`
* DATABASE NAME `wordpress`
* USER `admin`
* PASSWORD `admin`

#### WordPress Admin

* USER `admin`
* PASSWORD `admin`

## Customize Options

You can build a variety of environment that edit the configuration file of VAW.

There are two configuration files you can customize.

Run `vagrant up` or `vagrant provision`, after editing the configuration file.

### Vagrant configuration file (Ruby)

Vagrant configuration file is **Vagrantfile**.

Vagrantfile will set the vagrant Box, private IP address, hostname and the document root.

If you launch multiple environments, change the name of the directory. Should rewrite `vm_ip` and` vm_hostname`. Note not to overlap with other environments.

You can accesse from a terminal in the same LAN to use the public network to Vagrant virtual environment. To use public networks, set IP address for bridged connection to `public_ip`. In that case, recommended that configure the same IP address to `vm_hostname`.

	## Vagrant Settings ##
	vm_box                = 'vaw/centos6-default'
	vm_box_version        = '>= 0'
	vm_ip                 = '192.168.46.49'
	vm_hostname           = 'vaw.local'
	vm_document_root      = '/var/www/html'

	public_ip             = ''


* `vm_box` (required) name of Vagrant Box (default: `vaw/centos6-default`)
* `vm_box_version` (required) version of Vagrant Box (default: `>= 0`)
* `vm_ip` (required) private IP address (default: `192.168.46.49`)
* `vm_hostname` (required) hostname (default: `vaw.local`)
* `vm_document_root` (required) document root path (default: `/var/www/html`)
	* auto create `wordpress` directory and synchronized
* `public_ip` IP address of bridged connection (default: ``)

### Provisioning configuration file (YAML)

Provisioning configuration file is **group_vars/all.yml**.

In YAML format, you can set server, database and WordPress environment. And can enable the develop and deploy tools.

	## Server & Database Settings ##

	server             : 'apache'   # apache|nginx
	server_tuning      : false      # true|false

	# fastcgi is possible only server 'nginx'
	fastcgi            : 'php-fpm'  # php-fpm|hhvm

	database           : 'mysql'    # mysql|mariadb|percona
	db_root_password   : 'admin'

	db_host            : 'localhost'
	db_name            : 'wordpress'
	db_user            : 'admin'
	db_password        : 'admin'
	db_prefix          : 'wp_'

	## WordPress Settings ##

	title              : 'VAW (Vagrant Ansible WordPress)'
	admin_user         : 'admin'
	admin_password     : 'admin'
	admin_email        : 'hoge@example.com'

	# e.g. latest, 4.1, 4.1-beta1
	# see Release Archive - https://wordpress.org/download/release-archive/
	# 3.5.2 or later to work properly
	version            : 'latest'

	# e.g. en_US, ja
	# see wordpress-i18n list - http://svn.automattic.com/wordpress-i18n/
	lang               : 'en_US'

	# in own directory or subdirectory install.
	# see http://codex.wordpress.org/Giving_WordPress_Its_Own_Directory
	wp_dir             : ''   #e.g. /wordpress
	wp_site_path       : ''   #e.g. /wordpress

	multisite          : false   # true|false
	ssl_admin          : false   # true|false

	# theme slug|url|zip (local path, /vagrant/themes/~.zip) |empty ('')
	activate_theme     : ''
	# themes             :
	#                         - yoko
	#                         - Responsive

	# plugin slug|url|zip (local path, /vagrant/plugins/~.zip) |empty ('')
	activate_plugins   :
	                        - theme-check
	                        - plugin-check
	                        - log-deprecated-notices
	                        - debug-bar
	                        - query-monitor
	                        - broken-link-checker
	plugins            :
	                        - developer
	                        - monster-widget
	                        - wordpress-beta-tester

	# theme_mod          :
	#                        background_color: 'cccccc'

	# see Option Reference - http://codex.wordpress.org/Option_Reference
	# options            :
	#                        blogname: 'blog title'
	#                        blogdescription: 'blog description'

	# e.g. /%year%/%monthnum%/%postname%
	# see http://codex.wordpress.org/Using_Permalinks
	permalink_structure  :
	                      structure   : ''
	                      category    : ''
	                      tag         : ''

	# Any one of three ways to import
	import_xml_data    : ''   # local path, /vagrant/import/~.xml
	import_db_data     : ''   # local path, /vagrant/import/~.sql
	theme_unit_test    : false   # true|false

	replace_old_url         : ''   # to vm_hostname from old url
	regenerate_thumbnails   : false   # true|false

	## Develop & Deploy Settings ##

	WP_DEBUG           : true    # true|false
	SAVEQUERIES        : true    # true|false

	php_version        : 5.6.12

	develop_tools      : false   # true|false
	deploy_tools       : false   # true|false

	## That's all, stop setting. Let's vagrant up!! ##

	WP_URL             : '{{ HOSTNAME }}{{ wp_site_path }}'
	WP_PATH            : '{{ DOCUMENT_ROOT }}{{ wp_dir }}'

	WP_CLI             : '/usr/local/bin/wp'


#### Server & Database Settings ##

* `server` (required) name of web server (default: `apache` / value: `apache` | `nginx`)
* `server_tuning` server tuning mode (default: `false` / value: `true` | `false`)
* `fastcgi` name of fastCGI (default: `php-fpm` / value: `php-fpm` | `hhvm`)
	* `fastcgi` is possible only `server 'nginx'`
* `database` (required) name of databese (default: `mysql` / value: `mysql` | `mariadb` | `percona`)
* `db_root_password` (required) database root password (default: `admin`)
* `db_host` (required) database host (default: `localhost`)
* `db_name` (required) name of database (default: `wordpress`)
* `db_user` (required) database user name (default: `admin`)
* `db_password` (required) database user password (default: `admin`)
* `db_prefix` database prefix (default: `wp_`)

#### WordPress Settings ##

* `title` WordPress site title (default: `VAW (Vagrant Ansible WordPress)`)
* `admin_user` (required) WordPress admin user name (default: `admin`)
* `admin_password` (required) WordPress admin user password (default: `admin`)
* `admin_email` (required) WordPress admin email address (default: `hoge@example.com`)
* `version` (required) version of WordPress (default: `latest`)
	* e.g. `latest`, `4.1`, `4.1-beta1`
	* see [Release Archive](https://wordpress.org/download/release-archive/)
	* version 3.5.2 or later to work properly
* `lang` (required) WordPress in your language (default: `en_US`)
	* e.g. `en_US`, `ja`, ...
	* see [wordpress-i18n list](http://svn.automattic.com/wordpress-i18n/)

* `wp_dir` directory path to subdirectory install WordPress (default: install to document root)
* `wp_site_path` path of site (default: document root)
	* If `wp_dir` and `wp_site_path` are the same path, in own directory install.
	* If `wp_dir` and `wp_site_path` are different path, install to subdirectory. Note that `wp_site_path` be placed on one above the directory than `wp_dir`.
	* see [Giving WordPress Its Own Directory](http://codex.wordpress.org/Giving_WordPress_Its_Own_Directory)

* `multisite` Multisite enabled flag (default: `false` / value: `true` | `false`)
* `ssl_admin` administration over SSL enabled flag (default: `false` / value: `true` | `false`)
* `activate_theme` install a theme and activated (default: default theme)
	* set default theme `''`, `theme slug`, `zip file URL` or  `local zip file path`
	* set `/vagrant/themes/~.zip` by local zip file path
* `themes` install themes
	* set in YAML arrays of hashes format `theme slug`, `zip file URL` or `local zip file path`
	* set `/vagrant/themes/~.zip` by local zip file path
	* comment out with a `#` at the beginning of a line, if you want to disable the setting.

Configuration example

	themes             :
	                     - yoko
	                     - Responsive

Disable the setting case

	# themes             :
	#                      - yoko
	#                      - Responsive

* `activate_plugins` install plagins and activated
	* set in YAML arrays of hashes format `plagin slug`, `zip file URL` or `local zip file path`
	* set `/vagrant/plagins/~.zip` by local zip file path
	* comment out with a `#` at the beginning of a line, if you want to disable the setting.

Configuration example

	activate_plugins   :
	                        - theme-check
	                        - plugin-check

Disable the setting case

	# activate_plugins   :
	#                         - theme-check
	#                         - plugin-check

* `plugins` install plagins
	* set in YAML arrays of hashes format `plagin slug`, `zip file URL` or `local zip file path`
	* set `/vagrant/plagins/~.zip` by local zip file path
	* comment out with a `#` at the beginning of a line, if you want to disable the setting.

* `theme_mod` setting theme_mod (theme modification value)
	* see [set_theme_mod()](http://codex.wordpress.org/Function_Reference/set_theme_mod)
	* set in YAML nested hash format
	* comment out with a `#` at the beginning of a line, if you want to disable the setting.

Configuration example

	theme_mod          :
	                       background_color: 'cccccc'

Disable the setting case

	# theme_mod          :
	#                        background_color: 'cccccc'

* `options` setting options
	* see [update_option()](http://codex.wordpress.org/Function_Reference/update_option) and [Option Reference](http://codex.wordpress.org/Option_Reference)
	* set in YAML nested hash format
	* comment out with a `#` at the beginning of a line, if you want to disable the setting.

Configuration example

	options            :
	                       blogname: 'blog title'
	                       blogdescription: 'blog description'

Disable the setting case

	# options            :
	#                        blogname: 'blog title'
	#                        blogdescription: 'blog description'

* `permalink_structure` setting permalink structure
	* set the following three permalink structures
	* see [Using Permalinks](http://codex.wordpress.org/Using_Permalinks)
	* `structure` set the permalink structure using the structure tags
	* `category` set the prefix of the category archive
	* `tag` set the prefix of the tag archive

* `import_xml_data` local WordPress export (WXR) file path `/vagrant/import/~.xml`
	* Any one of three ways (`import_xml_data`, `import_db_data` or `theme_unit_test`) to import
* `import_db_data` local sql dump file path `/vagrant/import/~.sql`
	* Any one of three ways (`import_xml_data`, `import_db_data` or `theme_unit_test`) to import
* `theme_unit_test` import Theme Unit Test data enabled flag (default: `false` / value: `true` | `false`)
	* Any one of three ways (`import_xml_data`, `import_db_data` or `theme_unit_test`) to import
* `replace_old_url` replace to `vm_hostname` from `old url`
* `regenerate_thumbnails` regenerate thumbnails enabled flag (default: `false` / value: `true` | `false`)

#### Develop & Deploy Settings ##

* `WP_DEBUG` debug mode (default: `true` / value: `true` | `false`)
* `SAVEQUERIES` save the database queries (default: `true` / value: `true` | `false`)
* `php_version` version of PHP (default: 5.6.12)
* `develop_tools` activate develop tools (default: `false` / value: `true` | `false`)
* `deploy_tools` activate deploy tools (default: `false` / value: `true` | `false`)


## Directory Layout

Directory structure of VAW is as follows.

This directory synchronize to the guest OS side `/vagrant`. `wordpress` creates automatically and synchronize to `vm_document_root`.

`uploads` is the directory where stored images in `wp-content` directory of WordPress. `uploads` will be placed automatically in WordPress which was built at the time of provisioning, if you place `uploads` in this directory from the production environment.

You can create the same environment as the production environment, when you build a wordpress by import database dump data, substitution of url, regeneration of thumbnail image. You can set all from the provisioning configuration file.

### Full Layout

* backup (stores backup file. create automatically at running script, if it does not exist.)
* command (stores shell script)
* group_vars (stores the provisioning configuration file of Ansible)
	* all.yml (provisioning configuration file)
* hosts
	* development (inventory file)
* import (stores import data)
* plugins (stores WordPress plugin zip format files)
* Rakefile (Rakefile of ServerSpec)
* readme-ja.md
* readme.md
* roles (stores Ansible playbook of each role)
* site.yml (Ansible playbook core file)
* spec (stores ServerSpec spec file)
	* localhost
	* spec_helper.rb
* themes (stores WordPress theme zip format files)
* uploads (uploads directory in the wp-content)
* Vagrantfile (Vagrant configuration file)
* wordpress (synchronize to the Document Root. create automatically at `vagrant up`, if it does not exist.)

### Minimum Layout

VAW will be built in the directory structure of the following minimum unit.

* group_vars (stores the provisioning configuration file of Ansible)
	* all.yml (provisioning configuration file)
* roles (stores Ansible playbook of each role)
* site.yml (Ansible playbook core file)
* Vagrantfile (Vagrant configuration file)
* wordpress (synchronize to the Document Root. create automatically at `vagrant up`, if it does not exist.)


## Vagrant Box

Vagrant Box is probably compatible with centos-7.x x86_64 and centos-6.x x86_64.

By default, the Vagrantfile uses the `vaw/centos*-default` Box which has already provisioned default settings.

In addition, can use the `vaw/centos*-full` Box which has already provisioned default settings and activate develop and deploy tools.

You can build the environment in a short period of time compared with provisioning from the pure vagrant Box.

### CentOS 7

* [vaw/centos7-default](https://atlas.hashicorp.com/vaw/boxes/centos7-default)
* [vaw/centos7-full](https://atlas.hashicorp.com/vaw/boxes/centos7-full)

### CentOS 6

* [vaw/centos6-default](https://atlas.hashicorp.com/vaw/boxes/centos6-default)
* [vaw/centos6-full](https://atlas.hashicorp.com/vaw/boxes/centos6-full)


## Specification

### Server (Selectable)

* [Apache](http://httpd.apache.org)
* [nginx](http://nginx.org)

### FastCGI (Selectable, Only nginx)

* [PHP-FPM](http://php-fpm.org) (FastCGI Process Manager)
* [HHVM](http://hhvm.com) (HipHop Virtual Machine)

### Database (Selectable)

* [MySQL](http://www.mysql.com)
* [MariaDB](https://mariadb.org)
* [Percona MySQL](http://www.percona.com/software/percona-server)

### Pre-installing

* [WordPress](https://wordpress.org)
* [phpenv](https://github.com/CHH/phpenv)
* [php-build](https://php-build.github.io)
* [PHP](https://secure.php.net) ver.5.6.12 (Zend OPcache, APCu)
* [OpenSSL](https://www.openssl.org) (Selectable)
* [Composer](https://getcomposer.org/)
* [WP-CLI](http://wp-cli.org)
* [Git](http://git-scm.com)

### Develop Tools (Activatable)

* [Subversion](https://subversion.apache.org)
* [gettext](https://www.gnu.org/software/gettext/)
* [Node.js](http://nodejs.org)
* [npm](https://www.npmjs.com)
* [Grunt](http://gruntjs.com)
* [gulp.js](http://gulpjs.com)
* [Bower](Bower)
* [WordPress i18n tools](http://codex.wordpress.org/I18n_for_WordPress_Developers)
* [Xdebug](http://xdebug.org)
* [PHPUnit](https://phpunit.de)
* [PHPUnit Selenium](https://github.com/giorgiosironi/phpunit-selenium)
* [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer) & [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards)
* Opcache Web Viewer ([Opcache-Status](https://github.com/rlerdorf/opcache-status), [opcache-gui](https://github.com/amnuts/opcache-gui), [ocp.php](https://gist.github.com/ck-on/4959032/))
* [wrk - Modern HTTP benchmarking tool](https://github.com/wg/wrk)
* [plato](https://github.com/es-analysis/plato)
* [stylestats](https://github.com/t32k/stylestats)

### Deploy Tools (Activatable)

* [Capistrano](http://capistranorb.com)
* [Fabric](http://www.fabfile.org)
* [Dandelion](http://scttnlsn.github.io/dandelion/)
* [Wordmove](https://github.com/welaika/wordmove)

### Other

* [rbenv](https://github.com/sstephenson/rbenv)
* [ruby-build](https://github.com/sstephenson/ruby-build)
* [Ruby](https://www.ruby-lang.org/) ver.2.1.4

### Helper command

* db_backup.sh
* phpenv.sh

## Server Tuning Specification

As follows server tuning. It is in any time tuning.

### Apache

* [mod_cache](http://httpd.apache.org/docs/2.2/en/mod/mod_cache.html)
* [mod_deflate](http://httpd.apache.org/docs/2.2/en/mod/mod_deflate.html)
* [mod_expires](http://httpd.apache.org/docs/2.2/en/mod/mod_expires.html)
* [mod-pagespeed](https://code.google.com/p/modpagespeed/)

### nginx

* [gzip](http://nginx.org/en/docs/http/ngx_http_gzip_module.html)
* [proxy_cache](http://nginx.org/en/docs/http/ngx_http_proxy_module.html)
* [expires](http://nginx.org/en/docs/http/ngx_http_headers_module.html)


## Helper command

**VAW** offers a useful scripts. Just run the script on a terminal. Database data backup, multiple versions installation of PHP, you can switch the execution environment.

### db_backup.sh

`db_backup.sh` will back up the database. Save at `backup-% Y% m% d% H% M% S.sql` format in the `backup` folder.

	cd /var/www/html
	/vagrant/command/db_backup.sh

### phpenv.sh

`phpenv.sh` will prepare the specified version of PHP execution environment. You can install the specified version of PHP. Switching the PHP version. And then restart Apache or PHP-FPM by switching the server configuration environment.

	/vagrant/command/phpenv.sh 5.6.12

## Shortening of provisioning time by Vagrant plugin vagrant-cachier

When you install the Vagrant plugin **vagrant-cachier**, can shorten the provisioning time.

Installed package will be cached by the Box unit. When you launch multiple environments using the same Box, you can shorten the provisioning time using the cache.

#### How to delete cache

The cache is located in the host side, like this:

	ls -al $HOME/.vagrant.d/cache/

Delete the cache, the following command by Box.

	rm -rf $HOME/.vagrant.d/cache/vaw/centos7-default

or,

	rm -rf $HOME/.vagrant.d/cache/vaw/centos7-full

The command notation of if you are using the other Box.

	rm -rf $HOME/.vagrant.d/cache/<box-name>/<optional-bucket-name>

See [vagrant-cachier Usage](http://fgrehm.viewdocs.io/vagrant-cachier/usage).

## Contribute

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

If you would like to contribute, here are some notes and guidlines.

* All development happens on the **develop** branch, so it is always the most up-to-date
* The master branch only contains tagged releases
* If you are going to be submitting a pull request, please branch from **develop**, and submit your pull request back to the **develop** branch
* See about [forking](https://help.github.com/articles/fork-a-repo/) and [pull requests](https://help.github.com/articles/using-pull-requests/)

## Changelog

* version 0.2.1 - 2015.10.09
	* add stylestats
	* add plato
* version 0.2.0 - 2015.08.31
	* fix Fabric
	* fix WordPress plugins
	* fix rbenv and hhvm, MariaDB
	* fix memory 1.5GB
	* remove php55 and php-fpm roles
	* add command phpenv.sh
	* add phpenv, replaced from php
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

VAW is distributed under GPLv3.

Copyright (c) 2014-2015 thingsym
