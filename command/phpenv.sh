#!/usr/bin/env bash

set -e

usage_exit() {
  echo "[Info]: phpenv.sh version 0.1.2 for CentOS"
  echo "[Info]: Usage: phpenv.sh <-v x.x.x> <-m [mod_php|php-fpm]> <-s [tcp|unix]>"
  echo "[Info]: Usage: phpenv.sh <-v x.x.x> <-r>"
  echo "[Info]: Usage: phpenv.sh <[-l|-i|-h]>"
  exit 0
}

if [ "$#" -eq 0 ]; then
  echo "[Info]: Not Found Sub Commnad"
  exit 1
fi

while getopts "v:m:s:rlih" OPT ; do
  case $OPT in
    v)  PHP_VERSION=$OPTARG
        ;;
    m)  MODE=$OPTARG
        ;;
    s)  SOCKET=$OPTARG
        ;;
    r)  REMOVE=true
        ;;
    l)  phpenv install -l;
        exit 0
        ;;
    i)  phpenv versions;
        exit 0
        ;;
    h)  usage_exit
        ;;
    \?) usage_exit
        ;;
  esac
done

shift $(( $OPTIND - 1 ))

if [ -z "$PHP_VERSION" ]; then
  echo "Not Found PHP version"
  exit 1
fi

if [ -z "$SOCKET" ]; then
  SOCKET="unix"
fi

function global() {
  phpenv global $PHP_VERSION
  phpenv rehash

  if [ -f "$APACHE_PHP_CONF" ]; then
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

      phpenv apache-version ${PHP_VERSION}
    else
      sudo chown vagrant:vagrant /etc/httpd/conf.d/
      sed -i -e "s/^LoadModule php5_module/#LoadModule php5_module/" $APACHE_PHP_CONF
      sed -i -e "s/^LoadModule php7_module/#LoadModule php7_module/" $APACHE_PHP_CONF
      echo "[Info]: edit ${APACHE_PHP_CONF}"
      sudo chown root:root /etc/httpd/conf.d/
    fi
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
  fi

  phpenv install ${PHP_VERSION}

  if [ -d /etc/httpd/conf.d ] && [ ! -f "$APACHE_PHP_CONF" ]; then
    echo -e "#LoadModule php5_module modules/libphp5.so\n#LoadModule php7_module modules/libphp7.so\n\n<FilesMatch \.php$>\nSetHandler application/x-httpd-php\n</FilesMatch>\n\nDirectoryIndex index.php" > $APACHE_PHP_CONF
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
    sudo chown vagrant:vagrant /var/run/php-fpm
    echo "[Info]: add /var/run/php-fpm"
  fi

  if [ ! -d /var/log/php-fpm ]; then
    sudo mkdir /var/log/php-fpm
    sudo chown vagrant:vagrant /var/log/php-fpm
    echo "[Info]: add /var/log/php-fpm"
  fi

  if [ ! -f /var/log/php-fpm/error.log ]; then
    sudo touch /var/log/php-fpm/error.log
    sudo chmod 0666 /var/log/php-fpm/error.log
    sudo chown vagrant:vagrant /var/log/php-fpm/error.log
    echo "[Info]: add /var/log/php-fpm/error.log"
  fi

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

    if [ ! -f /etc/sysconfig/php-fpm ]; then
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
    sudo cp ${PHP_FPM_CONF}.default $PHP_FPM_CONF
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
    echo "[Info]: edit ${PHP_FPM_WWW_CONF}"
  fi

  if [ "$PHP_FPM_ACTIVE" -eq 0 ]; then
    if [ -f "$PHP_FPM_BIN" ]; then
      sudo cp $PHP_FPM_BIN /usr/sbin/php-fpm
      echo "[Info]: add ${PHP_FPM_BIN} to /usr/sbin/"
      sudo chmod 755 /usr/sbin/php-fpm
    fi

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
  APACHE_PHP_CONF="/etc/httpd/conf.d/php.conf"
  PHP_FPM_ACTIVE=`ps -ef | grep php-fpm.conf | grep -v grep | wc -l`
  PHP_INI="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php.ini"
  PHP_FPM_BIN="/home/vagrant/.phpenv/versions/${PHP_VERSION}/sbin/php-fpm"
  PHP_FPM_CONF="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php-fpm.conf"
  PHP_FPM_WWW_CONF="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php-fpm.d/www.conf"
  PHP_FPM_SERVICE="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/php-fpm.service"
  PHP_FPM_INITD="/home/vagrant/.phpenv/versions/${PHP_VERSION}/etc/init.d.php-fpm"
}

if [ "$REMOVE" = "true" ]; then
  remove
  exit 0
fi

gather_conf
if [ -e "/home/vagrant/.phpenv/versions/${PHP_VERSION}" ]; then
  global
else
  install
  global
fi

exit 0
