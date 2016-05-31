# VAW (Vagrant Ansible WordPress)

**VAW (Vagrant Ansible WordPress)** は、WordPress でウェブサイトを構築する開発者、サイト運営者、WordPress のテーマ・プラグイン開発者のための Ansible playbooks です。

Vagrant で開発環境やテスト環境を素早く立ち上げて、ウェブサイトの構築や動作検証ができます。もちろん、WordPress テーマやプラグインの開発も。

また、**VAW** は、開発パートナーやデザイナー、クライアントとポータブルに環境を共有してコラボレーションツールとして活用できます。

## Features

### 1. サーバ、データベース環境の構築

サーバは、**Apache**、**nginx** から、データベースは、**MySQL**、**MariaDB**、**Percona MySQL** から構成してサーバとデータベース環境の構築ができます。

サーバ nginx は、リバースプロキシとして FastCGI 構成で **PHP-FPM** (FastCGI Process Manager) と **HHVM** (HipHop Virtual Machine) から、PHP実行環境を構築します。

サーバ、データベースは基本、素の設定でインストールされますが、設定ファイルの編集でチューニングも可能。

様々な組み合わせのサーバとデータベース構成で検証が可能です。

### 2. WordPress 環境の構築

様々な設定やデータに処理を施した WordPress を構築します。テストデータや実データでの検証、本番環境のデータやファイルと同期した WordPress の構築が実現します。

* WordPress 本体のインストールバージョン指定
* WordPress 本体の言語指定
* インストールディレクトリ指定、サブディレクトリインストール
* マルチサイト対応
* 管理画面の SSL 化
* テーマのインストール
	* テーマの自動有効化
	* 複数のテーマを一括インストール
	* ローカルにあるテーマをインストール (開発中テーマや公式ディレクトリ未登録テーマに対応)
* プラグインのインストール
	* プラグインの自動有効化
	* 複数のプラグインを一括インストール
	* ローカルにあるプラグインをインストール (開発中プラグインや公式ディレクトリ未登録プラグインに対応)
* theme_mod (theme modification value) と Options の設定
* パーマリンク構造の設定
* データのインポートは 3 つのいずれかからインポートできます
	* XML (WXR) 形式
	* SQLデータ (データベースダンプデータ)
	* テストデータ (Theme Unit Test)
* uploads ディレクトリの wp-content へ自動配置
* 本番環境の URL からテスト環境の URL に置換処理
* サムネイル画像の再生成

### 3. Develop & Deploy ツール

プリインストールとしてプログラム言語 PHP のバージョン管理 「phpenv」、PHPパッケージ管理ツール「Composer」、WordPressのコマンドラインツール「WP-CLI」、ソースコードのバージョン管理ツール 「Git」が標準でインストール。

ウェブサイトの構築やテーマやプラグインの開発など用途によって Develop ツールと Deploy ツールがインストールできます。有効化によってインストールされるツールの一覧は Specification を参照。


## Requirements

* [Virtualbox](https://www.virtualbox.org)
* [Vagrant](https://www.vagrantup.com) >= 1.7.1 (Box centos-6.x x86_64)
* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) *optional (Vagrant plugin)
* [vagrant-cachier](http://fgrehm.viewdocs.io/vagrant-cachier) *optional (Vagrant plugin)
* [vagrant-serverspec](https://github.com/jvoorhis/vagrant-serverspec) *optional (Vagrant plugin)


## Usage

### 1. Virtualbox をインストール

[www.virtualbox.org](https://www.virtualbox.org) から環境にあった VirtualBox をダウンロードしてインストールします。

### 2. Vagrant をインストール

[www.vagrantup.com](https://www.vagrantup.com) から環境にあった Vagrant をダウンロードしてインストールします。

### 3. Vagrant plugin をインストール

必要に応じてターミナル上で Vagrant plugin をインストールします。

	vagrant plugin install vagrant-hostsupdater
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-serverspec


### 4. VAW の Ansible playbooks をダウンロード

以下のリンクから Vagrantfile と Ansible playbooks 一式をダウンロードします。

[Zip 形式で VAW をダウンロード](https://github.com/thingsym/vaw/archive/master.zip)

### 5. 仮想環境を立ち上げます

	cd vaw-x.x.x
	vagrant up

初回で Box がない場合、Box のダウンロードから始まり、プロビジョニング後、WordPress 環境が立ち上がります。

### 6. ウェブサイトと WordPress 管理画面にアクセス

初期設定でのウェブサイトへのアクセスは **http://vaw.local/** から、WordPress 管理画面は **http://vaw.local/wp-admin/** にブラウザでアクセスします。

## Default configuration Variables

初期設定のデータベースと WordPress Admin の ID とパスワードは以下の通りです。プロビジョニング設定ファイルで設定が可能です。

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

VAW は、設定ファイルを編集することで様々な環境が立ち上がります。カスタマイズできる設定ファイルは 2 種類あります。設定ファイルの編集後、`vagrant up` または、`vagrant provision` するだけ。

### Vagrant 設定ファイル (Ruby)

Vagrant 設定ファイルは、**Vagrantfile** です。
Vagrant で使う Box の指定 や プライベート IP アドレス、ホストネーム、ドキュメントルートの設定をします。

複数の環境を立ち上げる場合、ディレクトリ名を変更の上、他の環境と重ならないように `vm_ip` と `vm_hostname` を書き換えてください。

パブリックネットワークを使うと同じ LAN 内の端末から Vagrant 仮想環境にアクセスすることができます。パブリックネットワークを使うには、bridge 接続するための IP アドレスを設定します。その場合、`vm_hostname` に同じIP アドレスを設定することをお薦めします。

	## Vagrant Settings ##
	vm_box                = 'vaw/centos6-default'
	vm_box_version        = '>= 0'
	vm_ip                 = '192.168.46.49'
	vm_hostname           = 'vaw.local'
	vm_document_root      = '/var/www/html'

	public_ip             = ''


* `vm_box` (required) Vagrant Box 名 (default: `vaw/centos6-default`)
* `vm_box_version` (required) version of Vagrant Box (default: `>= 0`)
* `vm_ip` (required) プライベート IP アドレス (default: `192.168.46.49`)
* `vm_hostname` (required) ホストネーム (default: `vaw.local`)
* `vm_document_root` (required) ドキュメントルート (default: `/var/www/html`)
	* `wordpress` ディレクトリを自動的に作成して同期します
* `public_ip` bridge 接続する IP アドレス (default: ``)

### プロビジョニング設定ファイル (YAML)

プロビジョニング設定ファイルは、**group_vars/all.yml** です。
YAML 形式でサーバ、データベース、WordPress 環境の設定や Develop & Deploy ツールの有効化ができます。

	## Server & Database Settings ##

	server             : 'apache'   # apache|nginx

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

* `server` (required) ウェブサーバ名 (default: `apache` / value: `apache` | `nginx`)
* `fastcgi` fastCGI 名 (default: `php-fpm` / value: `php-fpm` | `hhvm`)
	* `fastcgi` は `server 'nginx'` のみ可能
* `database` (required) データベース名 (default: `mysql` / value: `mysql` | `mariadb` | `percona`)
* `db_root_password` (required) データベースの root パスワード (default: `admin`)
* `db_host` (required) データベースホスト名 (default: `localhost`)
* `db_name` (required) データベース名 (default: `wordpress`)
* `db_user` (required) データベースユーザ名 (default: `admin`)
* `db_password` (required) データベースパスワード (default: `admin`)
* `db_prefix` データベースプレフィックス名 (default: `wp_`)

#### WordPress Settings ##

* `title` サイトタイトル (default: `VAW (Vagrant Ansible WordPress)`)
* `admin_user` (required) WordPress 管理者ユーザー名 (default: `admin`)
* `admin_password` (required) WordPress 管理者パスワード (default: `admin`)
* `admin_email` (required) WordPress 管理者メールアドレス (default: `hoge@example.com`)
* `version` (required) WordPress 本体のバージョン (default: `latest`)
	* e.g. `latest`, `4.1`, `4.1-beta1`
	* [Release Archive](https://wordpress.org/download/release-archive/) を参照
	* バージョン 3.5.2 以降で正常に動作します

* `lang` (required) WordPress 本体の言語 (default: `en_US`)
	* e.g. `en_US`, `ja`, ...
	* [wordpress-i18n list](http://svn.automattic.com/wordpress-i18n/) を参照

* `wp_dir` サブディレクトリにインストールするディレクトリパス (default: ドキュメントルートにインストール)
* `wp_site_path` サイトパス (default: ドキュメントルート)
	*  `wp_dir` と `wp_site_path` が同じパスの場合、ディレクトリにインストールされます。
	* `wp_dir` と `wp_site_path` のパスが違う場合、サブディレクトリインストールになります。必ず `wp_site_path` は `wp_dir` より一つ上のディレクトリに置いてください。
	*  [Giving WordPress Its Own Directory](http://codex.wordpress.org/Giving_WordPress_Its_Own_Directory) を参照

* `multisite` マルチサイトの有効化 (default: `false` / value: `true` | `false`)
* `ssl_admin` 管理画面 SSL 化の有効化 (default: `false` / value: `true` | `false`)
* `activate_theme` テーマをインストール・有効化 (default: default theme)
	* デフォルトテーマ `''`, `theme slug`, `zip file URL`,  `local zip file path` から設定
	* ローカルにある zip ファイルパスは `/vagrant/themes/~.zip`
	* 自動的に有効化します
* `themes` テーマをインストール (複数可)
	* YAML 形式のハッシュの配列書式で設定 `theme slug`, `zip file URL`, `local zip file path`
	* ローカルにある zip ファイルパスは `/vagrant/themes/~.zip`
	* 設定を無効にする場合は、行頭に `#` を付けてコメントアウトします

設定例

	themes             :
	                     - yoko
	                     - Responsive

設定を無効にする場合

	# themes             :
	#                      - yoko
	#                      - Responsive

* `activate_plugins` プラグインのインストール・有効化 (複数可)
	* YAML 形式のハッシュの配列書式で設定 `plagin slug`, `zip file URL`, `local zip file path`
	* ローカルにある zip ファイルパスは `/vagrant/plagins/~.zip`
	* 自動的に有効化します
	* 設定を無効にする場合は、行頭に `#` を付けてコメントアウトします

設定例

	activate_plugins   :
	                        - theme-check
	                        - plugin-check

設定を無効にする場合

	# activate_plugins   :
	#                         - theme-check
	#                         - plugin-check

* `plugins` プラグインのインストール
	* YAML 形式のハッシュの配列書式で設定 `plagin slug`, `zip file URL`, `local zip file path`
	* ローカルにある zip ファイルパスは `/vagrant/plagins/~.zip`
	* 設定を無効にする場合は、行頭に `#` を付けてコメントアウトします
* `theme_mod` theme_mod (theme modification value) の設定
	* [set_theme_mod()](http://codex.wordpress.org/Function_Reference/set_theme_mod) を参照
	* YAML 形式のハッシュのネスト書式で設定
	* 設定を無効にする場合は、行頭に `#` を付けてコメントアウトします

設定例

	theme_mod          :
	                       background_color: 'cccccc'

設定を無効にする場合

	# theme_mod          :
	#                        background_color: 'cccccc'

* `options` オプションの設定
	* [update_option()](http://codex.wordpress.org/Function_Reference/update_option) と [Option Reference](http://codex.wordpress.org/Option_Reference) を参照
	* YAML 形式のハッシュのネスト書式で設定
	* 設定を無効にする場合は、行頭に `#` を付けてコメントアウトします

設定例

	options            :
	                       blogname: 'blog title'
	                       blogdescription: 'blog description'

設定を無効にする場合

	# options            :
	#                        blogname: 'blog title'
	#                        blogdescription: 'blog description'

* `permalink_structure` パーマリンク構造の設定
	* 以下の3つのパーマリンク構造の設定できます
	* [Using Permalinks](http://codex.wordpress.org/Using_Permalinks) を参照
	* `structure` Structure Tags で投稿のパーマリンク構造を設定
	* `category` カテゴリーアーカイブのカテゴリープレフィックスを設定
	* `tag` タグアーカイブのタグプレフィックスを設定

* `import_xml_data` WXR 形式のファイルパス `/vagrant/import/~.xml`
	* インポートは以下の3つのいずれか (`import_xml_data`, `import_db_data`, `theme_unit_test`)
* `import_db_data` SQL ダンプファイルパス `/vagrant/import/~.sql`
	* インポートは以下の3つのいずれか (`import_xml_data`, `import_db_data`, `theme_unit_test`)
* `theme_unit_test` テーマユニットテストデータのインポート有効化 (default: `false` / value: `true` | `false`)
	* インポートは以下の3つのいずれか (`import_xml_data`, `import_db_data`, `theme_unit_test`)
* `replace_old_url` `old url` から `vm_hostname` に置換
* `regenerate_thumbnails` サムネイル画像の再生成を有効化 (default: `false` / value: `true` | `false`)

#### Develop & Deploy Settings ##

* `WP_DEBUG` デバックモードを有効化 (default: `true` / value: `true` | `false`)
* `SAVEQUERIES` データベースクエリを保存 (default: `true` / value: `true` | `false`)
* `php_version` PHPバージョン (default: 5.6.12)
* `develop_tools` Develop ツールを有効化 (default: `false` / value: `true` | `false`)
* `deploy_tools` Deploy ツールを有効化 (default: `false` / value: `true` | `false`)

## Directory Layout

VAW のディレクトリ構成は以下の通りです。本ディレクトリは、ゲストOS側で `/vagrant` に同期します。また、`wordpress` は自動で作成されて Vagrant 設定ファイルで設定した Document Root `vm_document_root` に同期します。

`uploads` は WordPress の wp-content にある画像を格納したディレクトリです。本番環境から本ディレクトリに `uploads` をコピーして置くとプロビジョニング時に構築した WordPress に自動で配置されます。データベースのダンプデータのインポートと url の置換、サムネイル画像の再生成を活用して構築すると、本番環境と同じ環境が作れます。すべてプロビジョニング設定ファイルから設定できます。

### Full Layout

* backup (バックアップファイルを格納。無い場合、バックアップスクリプト起動時に自動作成)
* config (チューニング用設定ファイルを格納)
* command (シェルスクリプトを格納)
* group_vars (Ansible のプロビジョニング設定ファイルを格納)
	* all.yml (プロビジョニング設定ファイル)
* hosts
	* development (inventory file)
* import (インポートデータを格納)
* plugins (zip 形式のプラグインファイルを格納)
* Rakefile (ServerSpec の Rakefile)
* readme-ja.md
* readme.md
* roles (role 毎の Ansible playbook を格納)
* site.yml (Ansible playbook 本体ファイル)
* spec (ServerSpec spec file を格納)
	* localhost
	* spec_helper.rb
* themes (zip 形式のテーマファイルを格納)
* uploads (wp-content にある uploads ディレクトリ)
* Vagrantfile (Vagrant 設定ファイル)
* wordpress (Document Root に同期するディレクトリ、無い場合、`vagrant up` 時に自動作成)

### Minimum Layout

VAW は、以下の最小単位のディレクトリ構成でも環境が立ち上がります。

* group_vars (Ansible のプロビジョニング設定ファイルを格納)
	* all.yml (プロビジョニング設定ファイル)
* roles (Ansible playbook を格納)
* site.yml (Ansible playbook 本体ファイル)
* Vagrantfile (Vagrant 設定ファイル)
* wordpress (Document Root に同期するディレクトリ、無い場合、`vagrant up` 時に自動作成)


## Vagrant Box

Box は centos-7.x x86_64 系 と centos-6.x x86_64 系に対応しています。

VAW では、CentOS 7 と CentOS 6 用に 2 つずつ Box を用意しています。デフォルト設定のプロビジョニング済みの Box `vaw/centos*-default` と デフォルト設定に Develop ツールと Deploy ツールを有効化したプロビジョニング済みの Box `vaw/centos*-full`。真っさらな状態からのプロビジョニングと比べて短時間で環境が立ち上がります。

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

## Helper command

VAW には、便利なスクリプトを用意しています。ターミナル上でスクリプトを走らせるだけ。データベースのデータバックアップや PHP の複数バージョンインストール、実行環境の切り替えができます。

### db_backup.sh

データベースのデータをバックアップします。`backup` フォルダに `backup-%Y%m%d%H%M%S.sql` 形式で保存します。

	cd /var/www/html
	/vagrant/command/db_backup.sh

### phpenv.sh

指定したバージョンの PHP 実行環境を整えます。指定バージョンの PHP がインストールできます。PHPバージョン切り替えを行います。Apache や PHP-FPM のサーバ設定環境を切り替えて再起動します。

	/vagrant/command/phpenv.sh 5.6.12

## Custom Config

ディレクトリ `config` に編集したチューニング用設定ファイルを追加すると、プロビジョニング時に配置します。
チューニング用設定ファイルは以下の通り。

* httpd.conf.centos6.j2
* httpd.conf.centos7.j2
* httpd.www.conf.centos7.j2
* my.cnf.j2
* nginx.conf.j2
* nginx.multisite.conf.j2
* nginx.wordpress.conf.j2
* nginx.wordpress.multisite.conf.j2
* php-build.default_configure_options.j2
* php.conf.j2

## Vagrantプラグイン vagrant-cachier でプロビジョニング時間の短縮

Vagrantプラグイン **vagrant-cachier** をインストールするとプロビジョニング時間の短縮ができます。

キャッシュは Box 単位で必要なパッケージがキャッシュされて、同一の Box を利用して複数の環境を立ち上げるとそのキャッシュを利用したプロビジョニングを始めるので、時間の短縮が試せます。

#### キャッシュの削除方法

キャッシュの場所は、ホスト側の以下にあります。

	ls -al $HOME/.vagrant.d/cache/

キャッシュの削除は、Box によって以下のコマンドを。

	rm -rf $HOME/.vagrant.d/cache/vaw/centos7-default

または、

	rm -rf $HOME/.vagrant.d/cache/vaw/centos7-full

ほかの Box を使っている場合の記法は、

	rm -rf $HOME/.vagrant.d/cache/<box-name>/<optional-bucket-name>

詳しくは、[vagrant-cachier Usage](http://fgrehm.viewdocs.io/vagrant-cachier/usage) を参考に。

## 黒い画面が苦手な人も Vagrant Maneger で簡単に環境が立ち上がります

デザイナーやウェブサイト運営者など普段ターミナルに馴染みがない方や黒い画面が苦手だなぁと思っている方は Vagrant Maneger の導入をお薦めします。インストールすると、メニューバーにアイコンのメニューが追加されます。後はダウンロードした VAW をブックマークに登録して、メニューから `UP` を選ぶだけで環境が立ち上ります。Vagrant で操作する基本コマンドもほとんど用意されていて、コマンドを打つことから解放されたい方はどうぞ。

[Vagrant Maneger のインストールはこちらから](http://vagrantmanager.com)

## How to contribute

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

If you would like to contribute, here are some notes and guidlines.

* All development happens on the **develop** branch, so it is always the most up-to-date
* The **master** branch only contains tagged releases
* If you are going to be submitting a pull request, please submit your pull request to the **develop** branch
* See about [forking](https://help.github.com/articles/fork-a-repo/) and [pull requests](https://help.github.com/articles/using-pull-requests/)

## Changelog

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
