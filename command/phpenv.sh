#!/usr/bin/env bash

set -e

version() {
  echo "$(basename $0) version 0.4.1"
}

usage() {
    version
cat << EOF >&2

Usage:
  $(basename $0) [command]

Example:
  $(basename $0) -v 7.2.1 -m mod_php -s tcp

Main Commands:
  Install specific version php

    $(basename $0) <-v x.x.x> <-m [mod_php|php-fpm]> <-s [unix|tcp]>

    Parameters:
      -v    php version
      -m    [mod_php|php-fpm]    php execution environment
      -s    [unix|tcp]           UNIX socket or TCP/IP communincation

  Remove specific version php

    $(basename $0) <-v x.x.x> -r

    Parameters:
      -v    php version
      -r    remove flag

  Switch configuration parameter

    $(basename $0) <-v x.x.x> -c [<opcache|apcu|xdebug] [<on|off]

    Parameters:
      -v    php version
      -c    [<opcache|apcu|xdebug]    configuration target
      [<on|off]                       switch flag

Sub Commands:
  -l    List all available versions (alias phpenv install --list)
  -i    List all PHP versions available to phpenv (alias phpenv versions)
  -h    Display help text
EOF
}

if [ "$#" -eq 0 ]; then
  usage
  exit 1
fi

while getopts "v:m:s:c:rlih" OPT ; do
  case $OPT in
    v)  PHP_VERSION=$OPTARG
        ;;
    m)  MODE=$OPTARG
        ;;
    s)  SOCKET=$OPTARG
        ;;
    r)  COMMAND_LABEL='remove'
        ;;
    l)  $HOME/.phpenv/bin/phpenv install -l;
        exit 0
        ;;
    i)  $HOME/.phpenv/bin/phpenv versions;
        exit 0
        ;;
    c)  COMMAND_LABEL='config'
        TARGET=$OPTARG
        FLAG=$5
        ;;
    h)  usage
        exit 0
        ;;
    \?) usage
        exit 1
        ;;
  esac
done

shift $(( $OPTIND - 1 ))

if [ -z "$PHP_VERSION" ]; then
  echo "Not Found PHP version"
  echo "usage: $(basename $0) -h"
  exit 1
fi

if [ -z "$SOCKET" ]; then
  SOCKET="unix"
fi

function switch_config() {
  PHP_INI="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php.ini"
  XDEBUG_INI="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/conf.d/xdebug.ini"
  APCU_INI="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/conf.d/40-apcu.ini"

  if [ -f "$PHP_INI" ] && [ "$TARGET" = "opcache" ]; then
    if [ "$FLAG" = "on" ]; then
      sed -i -e "s/^;opcache.enable_cli=0/opcache.enable_cli=1/" $PHP_INI
      sed -i -e "s/^;opcache.enable=0/opcache.enable=1/" $PHP_INI
      sed -i -e "s/^;opcache.enable_cli=1/opcache.enable_cli=1/" $PHP_INI
      sed -i -e "s/^;opcache.enable=1/opcache.enable=1/" $PHP_INI
      sed -i -e "s/^opcache.enable_cli=0/opcache.enable_cli=1/" $PHP_INI
      sed -i -e "s/^opcache.enable=0/opcache.enable=1/" $PHP_INI
      echo "[Info]: edit ${PHP_INI}"
    elif [ "$FLAG" = "off" ]; then
      sed -i -e "s/^opcache.enable_cli=1/;opcache.enable_cli=0/" $PHP_INI
      sed -i -e "s/^opcache.enable=1/opcache.enable=0/" $PHP_INI
      echo "[Info]: edit ${PHP_INI}"
    fi
  fi

  if [ -f "$XDEBUG_INI" ] && [ "$TARGET" = "xdebug" ]; then
    if [ "$FLAG" = "on" ]; then
      sed -i -e "s/^;zend_extension/zend_extension/" $XDEBUG_INI
      echo "[Info]: edit ${XDEBUG_INI}"
    elif [ "$FLAG" = "off" ]; then
      sed -i -e "s/^zend_extension/;zend_extension/" $XDEBUG_INI
      echo "[Info]: edit ${XDEBUG_INI}"
    fi
  fi

  if [ -f "$APCU_INI" ] && [ "$TARGET" = "apcu" ]; then
    if [ "$FLAG" = "on" ]; then
      sed -i -e "s/^apc.enabled=0/apc.enabled=1/" $APCU_INI
      sed -i -e "s/^;apc.enable_cli=0/apc.enable_cli=1/" $APCU_INI
      sed -i -e "s/^apc.enable_cli=0/apc.enable_cli=1/" $APCU_INI
      sed -i -e "s/^;apc.shm_size=32M/apc.shm_size=32M/" $APCU_INI
      echo "[Info]: edit ${APCU_INI}"
    elif [ "$FLAG" = "off" ]; then
      sed -i -e "s/^apc.enabled=1/apc.enabled=0/" $APCU_INI
      sed -i -e "s/^apc.enable_cli=1/apc.enable_cli=0/" $APCU_INI
      echo "[Info]: edit ${APCU_INI}"
    fi
  fi

  echo "[Notice]: Please restart the server manually"

  exit 0
}

function gather_facts() {
  if [ -e /etc/os-release ]; then
    DISTR=$(awk '/PRETTY_NAME=/' /etc/os-release | sed 's/PRETTY_NAME=//' | sed 's/"//g' | awk '{print $1}' | tr '[:upper:]' '[:lower:]')
    if [ -e /etc/redhat-release ]; then
      VERSION=$(awk '{print $4}' /etc/redhat-release)
    elif [ "$DISTR" = "debian" ] && [ -e /etc/debian_version ]; then
      VERSION=$(awk '{print $1}' /etc/debian_version)
    else
      VERSION=$(awk '/VERSION_ID=/' /etc/os-release | sed 's/VERSION_ID=//' | sed 's/"//g')
    fi
    MAJOR=$(awk '/VERSION_ID=/' /etc/os-release | sed 's/VERSION_ID=//' | sed 's/"//g' | sed -E 's/\.[0-9]{2}//g')
    if [ -e /etc/lsb-release ]; then
      RELEASE=$(awk '/DISTRIB_CODENAME=/' /etc/lsb-release | sed 's/DISTRIB_CODENAME=//' | sed 's/"//g' | tr '[:upper:]' '[:lower:]')
    else
      RELEASE=$(awk '/PRETTY_NAME=/' /etc/os-release | sed 's/"//g' | awk '{print $4}' | sed 's/[\(\)]//g' | tr '[:upper:]' '[:lower:]')
    fi
  elif [ -e /etc/redhat-release ]; then
    DISTR=$(awk '{print $1}' /etc/redhat-release | tr '[:upper:]' '[:lower:]')
    VERSION=$(awk '{print $3}' /etc/redhat-release)
    MAJOR=$(awk '{print $3}' /etc/redhat-release | sed -E 's/\.[0-9]+//g')
    RELEASE=$(awk '{print $4}' /etc/redhat-release | sed 's/[\(\)]//g' | tr '[:upper:]' '[:lower:]')
  fi
  ARCH=$(uname -m)
  BITS=$(uname -m | sed 's/x86_//;s/amd//;s/i[3-6]86/32/')

  echo '[OS Info]'
  echo 'DISTRIBUTE:' $DISTR
  echo 'ARCHITECTURE:' $ARCH
  echo 'BITS:' $BITS
  echo 'RELEASE:' $RELEASE
  echo 'VERSION:' $VERSION
  echo 'MAJOR:' $MAJOR
}

function global() {
  $HOME/.phpenv/bin/phpenv global $PHP_VERSION
  $HOME/.phpenv/bin/phpenv rehash

  if [ -f "$APACHE_PHP_CONF" ]; then
    if [ "$DISTR" = "centos" ]; then
      if [ "$MODE" = "mod_php" ]; then
        sudo chown vagrant:vagrant /etc/httpd/conf.d/

        if [[ $PHP_VERSION =~ ^5 ]]; then
          sed -i -e "s/^#LoadModule php5_module/LoadModule php5_module/" $APACHE_PHP_CONF
          sed -i -e "s/^LoadModule php7_module/#LoadModule php7_module/" $APACHE_PHP_CONF
          echo "[Info]: edit ${APACHE_PHP_CONF}"
          sudo chown vagrant:vagrant /etc/httpd/modules/libphp5.so
        elif [[ $PHP_VERSION =~ ^7 ]]; then
          sed -i -e "s/^LoadModule php5_module/#LoadModule php5_module/" $APACHE_PHP_CONF
          sed -i -e "s/^#LoadModule php7_module/LoadModule php7_module/" $APACHE_PHP_CONF
          echo "[Info]: edit ${APACHE_PHP_CONF}"
          sudo chown vagrant:vagrant /etc/httpd/modules/libphp7.so
        fi

        sudo chown root:root /etc/httpd/conf.d/
      else
        sudo chown vagrant:vagrant /etc/httpd/conf.d/
        sed -i -e "s/^LoadModule php5_module/#LoadModule php5_module/" $APACHE_PHP_CONF
        sed -i -e "s/^LoadModule php7_module/#LoadModule php7_module/" $APACHE_PHP_CONF
        echo "[Info]: edit ${APACHE_PHP_CONF}"
        sudo chown root:root /etc/httpd/conf.d/
      fi
    fi

    if [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
      if [ "$MODE" = "mod_php" ]; then
        if [[ $PHP_VERSION =~ ^5 ]]; then
          [ -f /etc/apache2/mods-available/php7.load ] && sudo a2dismod php7
          [ -f /etc/apache2/mods-available/php5.load ] && sudo a2enmod php5
        elif [[ $PHP_VERSION =~ ^7 ]]; then
          [ -f /etc/apache2/mods-available/php5.load ] && sudo a2dismod php5
          [ -f /etc/apache2/mods-available/php7.load ] && sudo a2enmod php7
        fi
      fi
    fi

    $HOME/.phpenv/bin/phpenv apache-version ${PHP_VERSION}
  fi

  if [ "$MODE" = "php-fpm" ]; then
    if [ -f "$PHP_FPM_CONF" ]; then
      if [ "$SOCKET" = "unix" ]; then
        sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fcgi.pid/" $PHP_FPM_CONF
        echo "[Info]: ${SOCKET} connect"
      elif [ "$SOCKET" = "tcp" ]; then
        sed -i -e "s/^listen = \/var\/run\/php-fpm\/php-fcgi\.pid/listen = 127.0.0.1:9000/" $PHP_FPM_CONF
        echo "[Info]: ${SOCKET} connect"
      fi
      echo "[Info]: edit ${PHP_FPM_CONF}"
    fi

    if [ -f "$PHP_FPM_WWW_CONF" ]; then
      if [ "$SOCKET" = "unix" ]; then
        sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fcgi.pid/" $PHP_FPM_WWW_CONF
        echo "[Info]: ${SOCKET} connect"
      elif [ "$SOCKET" = "tcp" ]; then
        sed -i -e "s/^listen = \/var\/run\/php-fpm\/php-fcgi\.pid/listen = 127.0.0.1:9000/" $PHP_FPM_WWW_CONF
        echo "[Info]: ${SOCKET} connect"
      fi
      echo "[Info]: edit ${PHP_FPM_WWW_CONF}"
    fi

    if [ "$PHP_FPM_ACTIVE" -gt 0 ]; then
      if type systemctl > /dev/null 2>&1; then
        sudo systemctl stop php-fpm
      elif type service > /dev/null 2>&1; then
        sudo service php-fpm stop
      fi

      if [ -f "$PHP_FPM_BIN" ] && [ -d /usr/sbin ]; then
        sudo cp $PHP_FPM_BIN /usr/sbin/php-fpm
        echo "[Info]: add ${PHP_FPM_BIN} to /usr/sbin/"
        sudo chmod 755 /usr/sbin/php-fpm
      fi

      if [ "$DISTR" = "centos" ]; then
        if type systemctl > /dev/null 2>&1; then
          if [ -f "$PHP_FPM_SERVICE" ] && [ -d /usr/lib/systemd/system ]; then
            sudo cp $PHP_FPM_SERVICE /usr/lib/systemd/system/php-fpm.service
            echo "[Info]: add ${PHP_FPM_SERVICE} to /usr/lib/systemd/system/"
            sudo systemctl daemon-reload
          fi
        elif type service > /dev/null 2>&1; then
          if [ -f "$PHP_FPM_INITD" ] && [ -d /etc/init.d ]; then
            sudo cp $PHP_FPM_INITD /etc/init.d/php-fpm
            echo "[Info]: add ${PHP_FPM_INITD} to /etc/init.d/"
            sudo chmod 755 /etc/init.d/php-fpm
            sudo chkconfig --add php-fpm
          fi
        fi
      elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
        if type systemctl > /dev/null 2>&1; then
          if [ -f "$PHP_FPM_SERVICE" ] && [ -d /lib/systemd/system ]; then
            sudo cp $PHP_FPM_SERVICE /lib/systemd/system/php-fpm.service
            echo "[Info]: add ${PHP_FPM_SERVICE} to /lib/systemd/system/"
            sudo systemctl daemon-reload
          fi
        elif type service > /dev/null 2>&1; then
          if [ -f "$PHP_FPM_INITD" ] && [ -d /etc/init.d ]; then
            sudo cp $PHP_FPM_INITD /etc/init.d/php-fpm
            echo "[Info]: add ${PHP_FPM_INITD} to /etc/init.d/"
            sudo chmod 755 /etc/init.d/php-fpm
          fi
        fi
      fi

      if type systemctl > /dev/null 2>&1; then
        sudo systemctl start php-fpm
      elif type service > /dev/null 2>&1; then
        sudo service php-fpm start
      fi
    fi
  fi
}

function install() {
  if [ -d /etc/httpd/modules ]; then
    sudo chown vagrant:vagrant /etc/httpd/modules
    sudo chown vagrant:vagrant /etc/httpd/conf.d
  elif [ -d /usr/lib/apache2/modules ]; then
    sudo chown vagrant:vagrant /usr/lib/apache2/modules
    sudo chown vagrant:vagrant /etc/apache2/mods-available
    sudo chown vagrant:vagrant /etc/apache2/mods-enabled
    sudo chown vagrant:vagrant /var/lib/apache2
    sudo chown vagrant:vagrant /var/lib/apache2/module/enabled_by_admin
  fi

  $HOME/.phpenv/bin/phpenv install ${PHP_VERSION}

  if [ "$DISTR" = "centos" ] && [ -d /etc/httpd/conf.d ] && [ ! -f "$APACHE_PHP_CONF" ]; then
    echo -e "<IfModule prefork.c>\n#LoadModule php5_module modules/libphp5.so\n#LoadModule php7_module modules/libphp7.so\n</IfModule>\n\n<FilesMatch \.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>\n\nDirectoryIndex index.php" > $APACHE_PHP_CONF
    echo "[Info]: add ${APACHE_PHP_CONF}"
  elif ( [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ] ) && [ -d /etc/apache2/mods-available ] && [ ! -f "$APACHE_PHP_CONF" ]; then
    echo -e "<FilesMatch \.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>\n\nDirectoryIndex index.php" > $APACHE_PHP_CONF
    echo "[Info]: add ${APACHE_PHP_CONF}"
  fi

  if [ -d /etc/httpd/modules ]; then
    if [ -f /etc/httpd/modules/libphp5.so ] && [[ $PHP_VERSION =~ ^5 ]]; then
      cp /etc/httpd/modules/libphp5.so /home/vagrant/.phpenv/versions/${PHP_VERSION}/libphp5.so
      echo "[Info]: copy /etc/httpd/modules/libphp5.so to /home/vagrant/.phpenv/versions/${PHP_VERSION}/"
    fi

    if [ -f /etc/httpd/modules/libphp7.so ] && [[ $PHP_VERSION =~ ^7 ]]; then
      cp /etc/httpd/modules/libphp7.so /home/vagrant/.phpenv/versions/${PHP_VERSION}/libphp7.so
      echo "[Info]: copy /etc/httpd/modules/libphp7.so to /home/vagrant/.phpenv/versions/${PHP_VERSION}/"
    fi

    sudo chown root:root /etc/httpd/modules
    sudo chown root:root /etc/httpd/conf.d
  elif [ -d /usr/lib/apache2/modules ]; then
    if [ -f /usr/lib/apache2/modules/libphp5.so ] && [[ $PHP_VERSION =~ ^5 ]]; then
      cp /usr/lib/apache2/modules/libphp5.so /home/vagrant/.phpenv/versions/${PHP_VERSION}/libphp5.so
      echo "[Info]: copy /usr/lib/apache2/modules/libphp5.so to /home/vagrant/.phpenv/versions/${PHP_VERSION}/"
    fi

    if [ -f /usr/lib/apache2/modules/libphp7.so ] && [[ $PHP_VERSION =~ ^7 ]]; then
      cp /usr/lib/apache2/modules/libphp7.so /home/vagrant/.phpenv/versions/${PHP_VERSION}/libphp7.so
      echo "[Info]: copy /usr/lib/apache2/modules/libphp7.so to /home/vagrant/.phpenv/versions/${PHP_VERSION}/"
    fi

    sudo chown root:root /usr/lib/apache2/modules
    sudo chown root:root /etc/apache2/mods-available
    sudo chown root:root /etc/apache2/mods-enabled
    sudo chown root:root /var/lib/apache2
    sudo chown root:root /var/lib/apache2/module/enabled_by_admin
  fi

  if [ -f "$PHP_INI" ]; then
    sed -i -e "s/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" $PHP_INI
    sed -i -e "s/^display_errors = Off/display_errors = On/" $PHP_INI
    sed -i -e "s/^display_startup_errors = Off/display_startup_errors = On/" $PHP_INI
    sed -i -e "s/^track_errors = Off/track_errors = On/" $PHP_INI
    sed -i -e "s/^post_max_size = 8M/post_max_size = 32M/" $PHP_INI
    sed -i -e "s/^upload_max_filesize = 2M/upload_max_filesize = 32M/" $PHP_INI
    sed -i -e "s/^;mbstring.language = Japanese/mbstring.language = neutral/" $PHP_INI
    sed -i -e "s/^;mbstring.internal_encoding =/mbstring.internal_encoding = UTF-8/" $PHP_INI
    sed -i -e "s/^;date.timezone =/date.timezone = UTC/" $PHP_INI
    sed -i -e 's/^;session.save_path = \"\/tmp\"/session.save_path = \"\/tmp\"/' $PHP_INI

    sed -i -e "s/^;opcache.memory_consumption=64/opcache.memory_consumption=128/" $PHP_INI
    sed -i -e "s/^;opcache.interned_strings_buffer=4/opcache.interned_strings_buffer=8/" $PHP_INI
    sed -i -e "s/^;opcache.max_accelerated_files=2000/opcache.max_accelerated_files=4000/" $PHP_INI
    sed -i -e "s/^;opcache.revalidate_freq=2/opcache.revalidate_freq=60/" $PHP_INI
    sed -i -e "s/^;opcache.fast_shutdown=0/opcache.fast_shutdown=1/" $PHP_INI
    sed -i -e "s/^;opcache.enable_cli=0/opcache.enable_cli=0/" $PHP_INI
    sed -i -e "s/^;opcache.enable=0/opcache.enable=0/" $PHP_INI
    sed -i -e "s/^;opcache.enable_cli=1/opcache.enable_cli=0/" $PHP_INI
    sed -i -e "s/^;opcache.enable=1/opcache.enable=0/" $PHP_INI

    sed -i -e "s/^;sendmail_path =/sendmail_path = \/usr\/local\/bin\/mhsendmail/" $PHP_INI
    echo "[Info]: edit ${PHP_INI}"
  fi

  if [ ! -d /var/run/php-fpm ]; then
    sudo mkdir /var/run/php-fpm
    sudo chmod 755 /var/run/php-fpm
    echo "[Info]: add /var/run/php-fpm"
  fi

  if [ ! -d /var/log/php-fpm ]; then
    sudo mkdir /var/log/php-fpm
    echo "[Info]: add /var/log/php-fpm"
  fi

  if [ ! -f /var/log/php-fpm/error.log ]; then
    sudo touch /var/log/php-fpm/error.log
    sudo chmod 0666 /var/log/php-fpm/error.log
    echo "[Info]: add /var/log/php-fpm/error.log"
  fi

  sudo chown vagrant:vagrant /var/run/php-fpm
  sudo chown vagrant:vagrant /var/log/php-fpm
  sudo chown vagrant:vagrant /var/log/php-fpm/error.log


  if type systemctl > /dev/null 2>&1; then
    if [ -f "/tmp/php-build/source/${PHP_VERSION}/sapi/fpm/php-fpm.service" ]; then
      sudo cp /tmp/php-build/source/${PHP_VERSION}/sapi/fpm/php-fpm.service $PHP_FPM_SERVICE
      echo "[Info]: add ${PHP_FPM_SERVICE}"

      sed -i -e "s/^PIDFile=\${prefix}\/var\/run\/php-fpm.pid/PIDFile=\/run\/php-fpm.pid/" $PHP_FPM_SERVICE
      sed -i -e "s/^ExecStart=\${exec_prefix}\/sbin\/php-fpm --nodaemonize --fpm-config \${prefix}\/etc\/php-fpm.conf/ExecStart=\/usr\/sbin\/php-fpm --nodaemonize --fpm-config \/home\/vagrant\/.phpenv\/versions\/${PHP_VERSION}\/etc\/php-fpm.conf/" $PHP_FPM_SERVICE
      sed -i -e "8i EnvironmentFile=\/etc\/sysconfig\/php-fpm" $PHP_FPM_SERVICE
      sed -i -e "11i PrivateTmp=true" $PHP_FPM_SERVICE
      echo "[Info]: edit ${PHP_FPM_SERVICE}"
    fi

    if [ -d /etc/sysconfig ] && [ ! -f /etc/sysconfig/php-fpm ]; then
      sudo touch /etc/sysconfig/php-fpm
      sudo sh -c "echo '# Additional environment file for php-fpm' > /etc/sysconfig/php-fpm"
      echo "[Info]: add /etc/sysconfig/php-fpm"
    fi

    if [ ! -f /etc/tmpfiles.d/php-fpm.conf ]; then
      sudo touch /etc/tmpfiles.d/php-fpm.conf
      sudo sh -c "echo 'd /var/run/php-fpm 0775 vagrant vagrant' > /etc/tmpfiles.d/php-fpm.conf"
      echo "[Info]: add /etc/tmpfiles.d/php-fpm.conf"
    fi
  elif type service > /dev/null 2>&1; then
    if [ "$PHP_FPM_ACTIVE" -eq 0 ]; then
      if [ -f "/tmp/php-build/source/${PHP_VERSION}/sapi/fpm/init.d.php-fpm" ]; then
        sudo cp /tmp/php-build/source/${PHP_VERSION}/sapi/fpm/init.d.php-fpm $PHP_FPM_INITD
        echo "[Info]: add init.d.php-fpm to ${PHP_FPM_INITD}"
      fi
    fi
  fi

  if [ -f "${PHP_FPM_CONF}.default" ]; then
    sudo cp $PHP_FPM_CONF.default $PHP_FPM_CONF
    echo "[Info]: add ${PHP_FPM_CONF}"

    sed -i -e "s/^;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/" $PHP_FPM_CONF
    sed -i -e "s/^;error_log = log\/php-fpm.log/error_log = \/var\/log\/php-fpm\/error.log/" $PHP_FPM_CONF
    sed -i -e "s/^;daemonize = yes/daemonize = yes/" $PHP_FPM_CONF
    echo "[Info]: edit ${PHP_FPM_CONF} [global]"

    sed -i -e "s/^user = nobody/user = vagrant/" $PHP_FPM_CONF
    sed -i -e "s/^group = nobody/group = vagrant/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.owner = nobody/listen.owner = vagrant/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.group = nobody/listen.group = vagrant/" $PHP_FPM_CONF
    sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fcgi.pid/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.mode = 0660/listen.mode = 0660/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/" $PHP_FPM_CONF

    sed -i -e "s/^pm.max_children = 5/pm.max_children = 25/" $PHP_FPM_CONF
    sed -i -e "s/^pm.start_servers = 2/pm.start_servers = 10/" $PHP_FPM_CONF
    sed -i -e "s/^pm.min_spare_servers = 1/pm.min_spare_servers = 10/" $PHP_FPM_CONF
    sed -i -e "s/^pm.max_spare_servers = 3/pm.max_spare_servers = 20/" $PHP_FPM_CONF
    sed -i -e "s/^;pm.max_requests = 500/pm.max_requests = 500/" $PHP_FPM_CONF
    echo "[Info]: edit ${PHP_FPM_CONF} [www]"
  fi

  if [ -f "${PHP_FPM_WWW_CONF}.default" ]; then
    sudo cp ${PHP_FPM_WWW_CONF}.default $PHP_FPM_WWW_CONF
    echo "[Info]: add ${PHP_FPM_WWW_CONF}"

    sed -i -e "s/^user = nobody/user = vagrant/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^group = nobody/group = vagrant/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.owner = nobody/listen.owner = vagrant/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.group = nobody/listen.group = vagrant/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fcgi.pid/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.mode = 0660/listen.mode = 0660/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/" $PHP_FPM_WWW_CONF

    sed -i -e "s/^pm.max_children = 5/pm.max_children = 25/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^pm.start_servers = 2/pm.start_servers = 10/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^pm.min_spare_servers = 1/pm.min_spare_servers = 10/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^pm.max_spare_servers = 3/pm.max_spare_servers = 20/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;pm.max_requests = 500/pm.max_requests = 500/" $PHP_FPM_WWW_CONF

    sed -i -e "s/^;slowlog = log\/\$pool.log.slow/slowlog = \/var\/log\/php-fpm\/log.slow/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;request_slowlog_timeout = 0/request_slowlog_timeout = 10s/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;catch_workers_output = yes/catch_workers_output = yes/" $PHP_FPM_WWW_CONF
    echo "[Info]: edit ${PHP_FPM_WWW_CONF}"
  fi

  if [ "$PHP_FPM_ACTIVE" -eq 0 ]; then
    if [ -f "$PHP_FPM_BIN" ] && [ -d /usr/sbin ]; then
      sudo cp $PHP_FPM_BIN /usr/sbin/php-fpm
      echo "[Info]: add ${PHP_FPM_BIN} to /usr/sbin/"
      sudo chmod 755 /usr/sbin/php-fpm
    fi

    if [ "$DISTR" = "centos" ]; then
      if type systemctl > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_SERVICE" ] && [ -d /usr/lib/systemd/system ]; then
          sudo cp $PHP_FPM_SERVICE /usr/lib/systemd/system/php-fpm.service
          echo "[Info]: add ${PHP_FPM_SERVICE} to /usr/lib/systemd/system/"
          sudo systemctl daemon-reload
        fi
      elif type service > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_INITD" ] && [ -d /etc/init.d ]; then
          sudo cp $PHP_FPM_INITD /etc/init.d/php-fpm
          echo "[Info]: add ${PHP_FPM_INITD} to /etc/init.d/"
          sudo chmod 755 /etc/init.d/php-fpm
          sudo chkconfig --add php-fpm
        fi
      fi
    elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
      if type systemctl > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_SERVICE" ] && [ -d /lib/systemd/system ]; then
          sudo cp $PHP_FPM_SERVICE /lib/systemd/system/php-fpm.service
          echo "[Info]: add ${PHP_FPM_SERVICE} to /lib/systemd/system/"
          sudo systemctl daemon-reload
        fi
      elif type service > /dev/null 2>&1; then
        if [ -f "$PHP_FPM_INITD" ] && [ -d /etc/init.d ]; then
          sudo cp $PHP_FPM_INITD /etc/init.d/php-fpm
          echo "[Info]: add ${PHP_FPM_INITD} to /etc/init.d/"
          sudo chmod 755 /etc/init.d/php-fpm
        fi
      fi
    fi
  fi
}

function remove() {
  if [ -d "/home/vagrant/.phpenv/versions/${PHP_VERSION}" ]; then
    rm -rf /home/vagrant/.phpenv/versions/${PHP_VERSION}
    echo "Remove PHP ${PHP_VERSION}"
  else
    echo "Cannot remove PHP ${PHP_VERSION}"
  fi
}

function gather_conf() {
  if [ "$DISTR" = "centos" ]; then
    APACHE_PHP_CONF="/etc/httpd/conf.d/php.conf"
  elif [ "$DISTR" = "debian" ] || [ "$DISTR" = "ubuntu" ]; then
    if [[ $PHP_VERSION =~ ^5 ]]; then
      APACHE_PHP_CONF="/etc/apache2/mods-available/php5.conf"
    elif [[ $PHP_VERSION =~ ^7 ]]; then
      APACHE_PHP_CONF="/etc/apache2/mods-available/php7.conf"
    fi
  fi

  PHP_FPM_ACTIVE=`ps -ef | grep php-fpm.conf | grep -v grep | wc -l`
  PHP_INI="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php.ini"
  PHP_FPM_BIN="/home/vagrant/.phpenv/versions/${PHP_VERSION}/sbin/php-fpm"
  PHP_FPM_CONF="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php-fpm.conf"
  PHP_FPM_WWW_CONF="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php-fpm.d/www.conf"
  PHP_FPM_SERVICE="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php-fpm.service"
  PHP_FPM_INITD="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/init.d.php-fpm"
}

if [ "$COMMAND_LABEL" = "remove" ]; then
  remove
  exit 0
fi

if [ "$COMMAND_LABEL" = "config" ]; then
  switch_config
  exit 0
fi

gather_facts
gather_conf
if [ -e "/home/vagrant/.phpenv/versions/${PHP_VERSION}" ]; then
  global
else
  install
  global
fi

exit 0
