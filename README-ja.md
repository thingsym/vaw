# VAW (Vagrant Ansible WordPress)

**VAW (Vagrant Ansible WordPress)** は、WordPress でウェブサイトを構築する開発者、デザイナー、サイト運営者、WordPress のテーマ・プラグイン開発者のための **Ansible playbooks** です。

Vagrant で開発環境やテスト環境を素早く立ち上げて、ウェブサイトの構築や動作検証ができます。もちろん WordPress テーマやプラグインの開発も。

また、**VAW** は、開発パートナーやデザイナー、クライアントとポータブルに環境を共有してコラボレーションツールとして活用できます。

VAW (Vagrant Ansible WordPress) documentation: [https://thingsym.github.io/vaw/](https://thingsym.github.io/vaw/)

## Features

### 1. サーバ、データベース環境の構築

サーバは、**Apache**、**nginx**、**H2O** から、データベースは、**MariaDB**、**MySQL**、**Percona MySQL** から構成してサーバとデータベース環境の構築ができます。

すべてのウェブサーバで、FastCGI 構成が可能で **PHP-FPM** (FastCGI Process Manager) と **HHVM** (HipHop Virtual Machine) から、PHP実行環境を構築します。

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
	* ローカルにあるテーマをインストール (開発中テーマや公式ディレクトリ未掲載テーマに対応)
* プラグインのインストール
	* プラグインの自動有効化
	* 複数のプラグインを一括インストール
	* ローカルにあるプラグインをインストール (開発中プラグインや公式ディレクトリ未掲載プラグインに対応)
* theme_mod (theme modification value) と Options の設定
* パーマリンク構造の設定
* データのインポートは 4 つのいずれかからインポートできます
	* XML (WXR) 形式
	* SQLデータ (データベースダンプデータ)
	* バックアッププラグイン「BackWPup」アーカイブファイル (Zip, Tar, Tar GZip, Tar BZip2)
	* テストデータ (Theme Unit Test)
* wp-content ディレクトリの自動配置
* uploads ディレクトリの自動配置
* 本番環境の URL からテスト環境の URL に置換処理
* サムネイル画像の再生成

### 3. Develop & Deploy ツール

プリインストールとしてプログラム言語 PHP のバージョン管理 「phpenv」、PHPパッケージ管理ツール「Composer」、WordPressのコマンドラインツール「WP-CLI」、ソースコードのバージョン管理ツール 「Git」が標準でインストール。

ウェブサイトの構築やテーマやプラグインの開発など用途によって Develop ツールと Deploy ツールがインストールできます。有効化によってインストールされるツールの一覧は Specification を参照。

## Requirements

* [Oracle VM VirtualBox](https://www.virtualbox.org) >= 5.0
* [Vagrant](https://www.vagrantup.com) >= 1.8.4
* [Ansible](https://www.ansible.com) >= 2.2.1.0

#### Vagrant plugin (optional)

* [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
* [vagrant-serverspec](https://github.com/jvoorhis/vagrant-serverspec)

## Usage

### 1. Virtualbox をインストール

[www.virtualbox.org](https://www.virtualbox.org) から環境にあった VirtualBox をダウンロードしてインストールします。

### 2. Vagrant をインストール

[www.vagrantup.com](https://www.vagrantup.com) から環境にあった Vagrant をダウンロードしてインストールします。

### 3. Vagrant plugin をインストール

必要に応じてターミナル上で Vagrant plugin をインストールします。

	vagrant plugin install vagrant-hostsupdater
	vagrant plugin install vagrant-vbguest
	vagrant plugin install vagrant-serverspec


### 4. VAW の Ansible playbooks をダウンロード

以下のリンクから Vagrantfile と Ansible playbooks 一式をダウンロードします。

[Zip 形式で VAW をダウンロード](https://github.com/thingsym/vaw/archive/master.zip)

### 5. 仮想環境を立ち上げます

	cd vaw-x.x.x
	vagrant up

初回で Box がない場合、Box のダウンロードから始まります。
プロビジョニングが完了したら、WordPress開発環境が立ち上がります。

### 6. ウェブサイトと WordPress 管理画面にアクセス

初期設定でのウェブサイトへのアクセスは **http://vaw.local/** から、WordPress 管理画面は **http://vaw.local/wp-admin/** にブラウザでアクセスします。

## Default configuration Variables

初期設定のデータベースと WordPress Admin の ID とパスワードは以下の通りです。プロビジョニング設定ファイルで設定が可能です。

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

VAW は、設定ファイルを編集することで様々な環境が立ち上がります。カスタマイズできる設定ファイルは 2 種類あります。

* Vagrantfile
* group_vars/all.yml

設定ファイルの編集後、開発環境の立ち上げは、`vagrant up` または `vagrant provision` するだけ。

### Vagrant 設定ファイル (Ruby)

Vagrant 設定ファイルは、**Vagrantfile** です。
Vagrant で使う Box の指定 や プライベート IP アドレス、ホストネーム、ドキュメントルートの設定をします。

複数の環境を立ち上げる場合、ディレクトリ名を変更の上、他の環境と重ならないように `vm_ip` と `vm_hostname` を書き換えてください。

パブリックネットワークを使うと同じ LAN 内の端末から Vagrant 仮想環境にアクセスすることができます。パブリックネットワークを使うには、bridge 接続するための IP アドレスを設定します。その場合、`vm_hostname` に同じIP アドレスを設定することをお薦めします。

	## Vagrant Settings ##
	vm_box                = 'bento/centos-7.4'
	vm_box_version        = '>= 0'
	vm_ip                 = '192.168.46.49'
	vm_hostname           = 'vaw.local'
	vm_document_root      = '/var/www/html'

	public_ip             = ''

	vbguest_auto_update   = false

	ansible_install_mode  = :default    # :default|:pip
	ansible_version       = 'latest'    # only :pip required

	provision_mode        = 'all'       # all|wordpress|box

* `vm_box` (required) Vagrant Box 名 (default: `bento/centos-7.4`)
* `vm_box_version` (required) version of Vagrant Box (default: `>= 0`)
* `vm_ip` (required) プライベート IP アドレス (default: `192.168.46.49`)
* `vm_hostname` (required) ホストネーム (default: `vaw.local`)
* `vm_document_root` (required) ドキュメントルート (default: `/var/www/html`)
	* `wordpress` ディレクトリを自動的に作成して同期します
* `public_ip` bridge 接続する IP アドレス (default: `''`)
* `vbguest_auto_update` VirtualBox Guest Additions をアップデートします (default: `false` / value: `true` | `false`)
* `ansible_install_mode` (required)  Ansible のインストール方法 (default: `:default` / value: `:default` | `:pip`)
* `ansible_version` インストールする Ansible のバージョン (default: `latest`)
* `provision_mode` (required) プロビジョニングモード (default: `all` / value: `all` | `wordpress` | `box`)

### プロビジョニング設定ファイル (YAML)

プロビジョニング設定ファイルは、**group_vars/all.yml** です。
YAML 形式でサーバ、データベース、WordPress 環境の設定や Develop & Deploy ツールの有効化ができます。

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
	# 3.5.2 or later to work properly
	version            : latest

	# e.g. en_US, ja, ...
	# see wordpress-i18n list - http://svn.automattic.com/wordpress-i18n/
	lang               : en_US

	# in own directory or subdirectory install.
	# see http://codex.wordpress.org/Giving_WordPress_Its_Own_Directory
	wp_dir             : ''   #e.g. /wordpress
	wp_site_path       : ''   #e.g. /wordpress

	multisite          : false   # true|false

	# default theme|slug|url|zip (local path, /vagrant/themes/~.zip)
	activate_theme     : ''
	themes             : []

	# slug|url|zip (local path, /vagrant/plugins/~.zip)
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
	import_xml_data    : ''   # local path, /vagrant/import/~.xml
	import_db_data     : ''   # local path, /vagrant/import/~.sql
	import_backwpup    :
	                      path          : ''   # local path, /vagrant/import/~.zip
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

* `server` (required) ウェブサーバ名 (default: `apache` / value: `apache` | `nginx` | `h2o`)
* `fastcgi` fastCGI 名 (default: `none` / value: `none` | `php-fpm` | `hhvm`)
* `database` (required) データベース名 (default: `mariadb` / value: `mariadb` | `mysql` | `percona`)
* `db_root_password` (required) データベースの root パスワード (default: `admin`)
* `db_host` (required) データベースホスト名 (default: `localhost`)
* `db_name` (required) データベース名 (default: `wordpress`)
* `db_user` (required) データベースユーザ名 (default: `admin`)
* `db_password` (required) データベースパスワード (default: `admin`)
* `db_prefix` データベースのプレフィックス名 (default: `wp_`)
* `db_charset` データベースの文字コード (default: `''`)
* `db_collate` データベースの照合順序 (default: `''`)

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
	* `wp_dir` と `wp_site_path` が同じパスの場合、ディレクトリにインストールされます。
	* `wp_dir` と `wp_site_path` のパスが違う場合、サブディレクトリインストールになります。必ず `wp_site_path` は `wp_dir` より一つ上のディレクトリに置いてください。
	*  [Giving WordPress Its Own Directory](http://codex.wordpress.org/Giving_WordPress_Its_Own_Directory) を参照

* `multisite` マルチサイトの有効化 (default: `false` / value: `true` | `false`)
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

	themes             : []

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

	activate_plugins   : []

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

	theme_mod          : {}

* `options` オプションの設定
	* [update_option()](http://codex.wordpress.org/Function_Reference/update_option) と [Option Reference](http://codex.wordpress.org/Option_Reference) を参照
	* YAML 形式のハッシュのネスト書式で設定
	* 設定を無効にする場合は、行頭に `#` を付けてコメントアウトします

設定例

	options            :
	                       blogname: 'blog title'
	                       blogdescription: 'blog description'

設定を無効にする場合

	options            : {}

* `permalink_structure` パーマリンク構造の設定
	* 以下の3つのパーマリンク構造の設定できます
	* [Using Permalinks](http://codex.wordpress.org/Using_Permalinks) を参照
	* `structure` Structure Tags で投稿のパーマリンク構造を設定
	* `category` カテゴリーアーカイブのカテゴリープレフィックスを設定
	* `tag` タグアーカイブのタグプレフィックスを設定
* `import_xml_data` WXR 形式のファイルパス `/vagrant/import/~.xml`
* `import_db_data` SQL ダンプファイルパス `/vagrant/import/~.sql`
* `import_backwpup`
	* `path` アーカイブファイルパス `/vagrant/import/~.zip` (Zip, Tar, Tar GZip, Tar BZip2)
	* `db_data_file` DBバックアップファイル名 (データファイルのどちらかひとつからインポート)
	* `xml_data_file` XML エクスポートファイル名 (データファイルのどちらかひとつからインポート)
* `import_admin` WordPress 管理者ユーザーの追加 (default: `false` / value: `true` | `false`)
* `theme_unit_test` テーマユニットテストデータのインポート有効化 (default: `false` / value: `true` | `false`)
* `replace_old_url` `old url` から `vm_hostname` に置換
* `regenerate_thumbnails` サムネイル画像の再生成を有効化 (default: `false` / value: `true` | `false`)
* `WP_DEBUG` デバックモードを有効化 (default: `true` / value: `true` | `false`)
* `SAVEQUERIES` データベースクエリを保存 (default: `true` / value: `true` | `false`)

#### Develop & Deploy Settings ##

* `ssl` WordPress管理画面 SSL 化の有効化 (default: `false` / value: `true` | `false`)
* `php_version` PHPバージョン (default: `7.2.1`)
* `http_protocol` HTTP プロトコル (default: `http` / value: `http` | `https`)
* `develop_tools` Develop ツールを有効化 (default: `false` / value: `true` | `false`)
* `deploy_tools` Deploy ツールを有効化 (default: `false` / value: `true` | `false`)

## Directory Layout

VAW のディレクトリ構成は以下の通りです。本ディレクトリは、ゲストOS側で `/vagrant` に同期します。また、`wordpress` は自動で作成されて Vagrant 設定ファイルで設定した Document Root `vm_document_root` に同期します。

`wp-content` は WordPress のテーマやプラグイン、アップロードファイルを格納したディレクトリです。本番環境から本ディレクトリに `wp-content` をコピーして置くとプロビジョニング時に構築した WordPress に自動で配置されます。

`uploads` は WordPress の wp-content にあるアップロードファイルを格納したディレクトリです。本番環境から本ディレクトリに `uploads` をコピーして置くとプロビジョニング時に構築した WordPress に自動で配置されます。

データベースのダンプデータのインポートと url の置換、サムネイル画像の再生成を活用して構築すると、本番環境と同じ環境が作れます。すべてプロビジョニング設定ファイルから設定できます。

### Full Layout

* backup (バックアップファイルを格納。無い場合、バックアップスクリプト起動時に自動作成)
* command (シェルスクリプトを格納)
* config (チューニング用設定ファイルを格納)
* config.sample (チューニング用設定ファイルサンプル)
* group_vars (Ansible のプロビジョニング設定ファイルを格納)
	* all.yml (プロビジョニング設定ファイル)
* hosts
	* local (inventory file)
* import (インポートデータを格納)
* LICENSE (ライセンスファイル)
* plugins (zip 形式のプラグインファイルを格納)
* Rakefile (ServerSpec の Rakefile)
* README-ja.md
* README.md
* roles (role 毎の Ansible playbook を格納)
* site.yml (Ansible playbook 本体ファイル)
* spec (ServerSpec spec file を格納)
	* box
	* localhost
	* spec_helper.rb
	* sync-dir
* themes (zip 形式のテーマファイルを格納)
* uploads (WordPress の wp-content にある uploads ディレクトリ)
* Vagrantfile (Vagrant 設定ファイル)
* wordpress (Document Root に同期するディレクトリ、無い場合、`vagrant up` 時に自動作成)
* wp-content (WordPress の wp-content ディレクトリ)

### Minimum Layout

VAW は、以下の最小単位のディレクトリ構成でも環境が立ち上がります。

* group_vars (Ansible のプロビジョニング設定ファイルを格納)
	* all.yml (プロビジョニング設定ファイル)
* hosts
	* local (inventory file)
* roles (Ansible playbook を格納)
* site.yml (Ansible playbook 本体ファイル)
* Vagrantfile (Vagrant 設定ファイル)
* wordpress (Document Root に同期するディレクトリ、無い場合、`vagrant up` 時に自動作成)

## Vagrant Box

VAW は、Vagrant のプロバイダ VirtualBox をサポートしています。
OS とアーキテクチャは、centos-7.x x86_64 系 と centos-6.x x86_64 系 Vagrant Box に対応しています。Vagrant Box のダウンロードは、[Discover Vagrant Boxes](https://app.vagrantup.com/boxes/search?provider=virtualbox) から検索できます。

VAW では、あらかじめ CentOS 7 と CentOS 6 用に 2 つずつ Box を用意しています。デフォルト設定のプロビジョニング済みの Box `vaw/centos*-default` と デフォルト設定に Develop ツールと Deploy ツールを有効化したプロビジョニング済みの Box `vaw/centos*-full`。真っさらな状態からのプロビジョニングと比べて短時間で環境が立ち上がります。

### CentOS 7

* [vaw/centos7-default](https://atlas.hashicorp.com/vaw/boxes/centos7-default)
* [vaw/centos7-full](https://atlas.hashicorp.com/vaw/boxes/centos7-full)

### CentOS 6

* [vaw/centos6-default](https://atlas.hashicorp.com/vaw/boxes/centos6-default)
* [vaw/centos6-full](https://atlas.hashicorp.com/vaw/boxes/centos6-full)

## プロビジョニングモード

VAW には、3つのプロビジョニングモードがあります。

* `all` は、まっさらな Vagrant Box から通常のプロビジョニングを行います。
* `wordpress` は、WordPress が含まれた同期フォルダだけプロビジョニングをします。
* `box` は、Vagrant Box を作成するためのプロビジョニングをします。

VAW は、いろんなサーバ、データベース構成の組み合わせでプロビジョニングできることが特徴です。
その反面、まっさらな Vagrant Box から環境を構築することは、プロビジョニングに時間がかかります。

あらかじめサーバ、データベース構成を設定した Vagrant Box を作成できます。
作った Vagrant Box を使い回すことでプロビジョニングの時間短縮が図れます。

まず、Provision mode `box` で Vagrant Box を作成します。
次に、作成した Vagrant Box を Provision mode `wordpress` でプロビジョニングします。
作成した Vagrant Boxをベースに WordPress開発環境が素早く立ち上がります。


## Vagrant Box の作り方

プロビジョニングモードをどのように活用するのか。

Vagrant Box の作り方から、つくった Vagrant Box でプロビジョニングして WordPress開発環境を構築するまでの流れを通じて見てみましょう。

### 1. 設定ファイルの設定

Vagrant Box 作成するため Vagrant 環境を立ち上げます。
まず、Vagrant 設定ファイルとプロビジョニング設定ファイルの設定をします。

Vagrant 設定ファイルの `provision_mode` を `box` に設定。

	provision_mode        = 'box'    # all|wordpress|box

プロビジョニング設定ファイルの設定はお好みで。
ただし、`provision_mode` が `box` 場合、
プロビジョニング時にプロビジョニング設定ファイルの WordPress Settings セクションがスキップされます。

### 2. プロビジョニング

プロビジョニングをして環境を構築します。

	vagrant up

### 3. Vagrant Box の作成 (パッケージ化)

プロビジョニングが完了したら、box 名を付けて Vagrant Box を作成します。 (e.g. sample.box)

	vagrant package --output sample.box

### 4. Vagrant Box の登録

作成した Vagrant Box を Vagrant に追加します。(e.g. VM名 sample として登録)

	vagrant box add sample.box --name sample

Vagrant Box 作成のために作った Vagrant Box は、削除して構いません。 (e.g. sample.box)
立ち上げた Vagrant環境は、動作確認後に削除して構いません。

	vagrant destroy

### 5. 作成した Vagrant Box でプロビジョニング

作成した Vagrant Box でWordPress開発用に Vagrant環境を立ち上げます。
Vagrant 設定ファイルとプロビジョニング設定ファイルの設定をします。

Vagrant 設定ファイルの `vm_box` を `sample` に設定。 (e.g. VM名 sample)
Vagrant 設定ファイルの `provision_mode` を `wordpress` に設定。

	vm_box                = 'sample'
	...
	provision_mode        = 'wordpress'    # all|wordpress|box

プロビジョニング設定ファイルの設定はお好みで。
`provision_mode` が `wordpress` 場合、
プロビジョニング時にプロビジョニング設定ファイルの WordPress Settings セクションだけが有効になります。

### 6. 仮想環境を立ち上げます

	vagrant up

プロビジョニングが完了したら、WordPress開発環境が立ち上がります。

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

* [Capistrano](http://capistranorb.com)
* [Fabric](http://www.fabfile.org)
* [Dandelion](http://scttnlsn.github.io/dandelion/)
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

VAW には、便利なスクリプトを用意しています。ターミナル上でスクリプトを走らせるだけ。データベースのデータバックアップや PHP の複数バージョンインストール、実行環境の切り替えができます。

### db_backup.sh

データベースのデータをバックアップします。`backup` フォルダに `backup-%Y%m%d%H%M%S.sql` 形式で保存します。

	cd /var/www/html
	/vagrant/command/db_backup.sh

### phpenv.sh

指定したバージョンの PHP 実行環境を整えます。指定バージョンの PHP がインストールできます。PHPバージョン切り替えを行います。Apache や PHP-FPM のサーバ設定環境を切り替えて再起動します。

	/vagrant/command/phpenv.sh -v 7.2.1 -m php-fpm -s unix

	# help
	/vagrant/command/phpenv.sh -h

## Custom Config

ディレクトリ `config` に編集したチューニング用設定ファイルを追加すると、プロビジョニング時に配置します。
チューニング用設定ファイルは以下の通り。

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

## 黒い画面が苦手な人も Vagrant Maneger で簡単に環境が立ち上がります

デザイナーやウェブサイト運営者など普段ターミナルに馴染みがない方や黒い画面が苦手だなぁと思っている方は Vagrant Maneger の導入をお薦めします。インストールすると、メニューバーにアイコンのメニューが追加されます。後はダウンロードした VAW をブックマークに登録して、メニューから `UP` を選ぶだけで環境が立ち上ります。Vagrant で操作する基本コマンドもほとんど用意されていて、コマンドを打つことから解放されたい方はどうぞ。

[Vagrant Maneger のインストールはこちらから](http://vagrantmanager.com)

## Contribution

### Patches and Bug Fixes

Small patches and bug reports can be submitted a issue tracker in Github. Forking on Github is another good way. You can send a pull request.

1. Fork [VAW](https://github.com/thingsym/vaw) from GitHub repository
2. Create a feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Create new Pull Request

## Changelog

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
