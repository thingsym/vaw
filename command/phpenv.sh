#!/usr/bin/env bash

set -e

usage_exit() {
  echo "[Error]: Not Found PHP version"
  echo "[Info]: phpenv.sh version 0.1.1 for CentOS"
  echo "[Info]: Usage: phpenv.sh <[Version Number|-v x.x.x]> <-m [mod_php|php-fpm]>"
  echo "[Info]: or Not Found Sub Commnad"
  echo "[Info]: Usage: phpenv.sh <[-l|-i|-h]>"
  exit 1
}

if [ "$#" -eq 0 ]; then
  usage_exit
fi

while getopts "v:m:rlih" OPT ; do
  case $OPT in
    v)  PHP_VERSION=$OPTARG
        ;;
    m)  MODE=$OPTARG
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

if [ ! "$PHP_VERSION" ]; then
  PHP_VERSION=$1
fi

function global() {
  phpenv global $PHP_VERSION

  if [[ -f "$HTTPD_PHP_CONF" ]]; then
    if [ "$MODE" = "mod_php" ]; then
      sudo chown vagrant:vagrant /etc/httpd/conf.d/
      if [[ $PHP_VERSION =~ ^5 ]]; then
        sed -i -e "s/^#LoadModule php5_module/LoadModule php5_module/" $HTTPD_PHP_CONF
        sed -i -e "s/^LoadModule php7_module/#LoadModule php7_module/" $HTTPD_PHP_CONF
        echo "[Info]: edit $HTTPD_PHP_CONF"
        sudo chown vagrant:vagrant /etc/httpd/modules/libphp5.so
      elif [[ $PHP_VERSION =~ ^7 ]]; then
        sed -i -e "s/^LoadModule php5_module/#LoadModule php5_module/" $HTTPD_PHP_CONF
        sed -i -e "s/^#LoadModule php7_module/LoadModule php7_module/" $HTTPD_PHP_CONF
        echo "[Info]: edit $HTTPD_PHP_CONF"
        sudo chown vagrant:vagrant /etc/httpd/modules/libphp7.so
      fi

      sudo chown root:root /etc/httpd/conf.d/

      phpenv apache-version $PHP_VERSION
    else
      sudo chown vagrant:vagrant /etc/httpd/conf.d/
      sed -i -e "s/^LoadModule php5_module/#LoadModule php5_module/" $HTTPD_PHP_CONF
      sed -i -e "s/^LoadModule php7_module/#LoadModule php7_module/" $HTTPD_PHP_CONF
      echo "[Info]: edit $HTTPD_PHP_CONF"
      sudo chown root:root /etc/httpd/conf.d/
    fi
  fi

  if [ "$MODE" = "php-fpm" ]; then
    if [[ $PHP_FPM_ACTIVE > 0 ]]; then
      if type systemctl > /dev/null 2>&1; then
        sudo systemctl stop php-fpm
      elif type service > /dev/null 2>&1; then
        sudo service php-fpm stop
      fi

      if [[ $OS_VERSION =~ ^6 ]]; then
        if [[ -f /tmp/php-build/source/$PHP_VERSION/sapi/fpm/init.d.php-fpm ]]; then
          sudo cp /tmp/php-build/source/$PHP_VERSION/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
          echo "[Info]: add init.d.php-fpm to /etc/init.d/"
          sudo chmod 755 /etc/init.d/php-fpm
        fi

        if [[ -f /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm ]]; then
          sudo cp /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm /usr/sbin/php-fpm
          echo "[Info]: add php-fpm to /usr/sbin/"
          sudo chmod 755 /usr/sbin/php-fpm
        fi
      elif [[ $OS_VERSION =~ ^7 ]]; then
        if [[ -f $PHP_FPM_SERVICE ]]; then
          sudo cp $PHP_FPM_SERVICE /usr/lib/systemd/system/php-fpm.service
          echo "[Info]: add php-fpm.service to /usr/lib/systemd/system/"
          sudo systemctl daemon-reload
        fi

        if [[ -f /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm ]]; then
          sudo cp /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm /usr/sbin/php-fpm
          echo "[Info]: add php-fpm to /usr/sbin/"
          sudo chmod 755 /usr/sbin/php-fpm
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
  if [[ -d /etc/httpd/modules ]]; then
    sudo chown vagrant:vagrant /etc/httpd/modules
  fi

  phpenv install $PHP_VERSION /home/vagrant/.phpenv/versions/$PHP_VERSION

  if [[ -d /etc/httpd/modules ]]; then
    if [[ -f /etc/httpd/modules/libphp5.so ]]; then
      cp /etc/httpd/modules/libphp5.so /home/vagrant/.phpenv/versions/$PHP_VERSION/libphp5.so
      echo "[Info]: copy /etc/httpd/modules/libphp5.so to /home/vagrant/.phpenv/versions/$PHP_VERSION/"
    fi

    if [[ -f /etc/httpd/modules/libphp7.so ]]; then
      cp /etc/httpd/modules/libphp7.so /home/vagrant/.phpenv/versions/$PHP_VERSION/libphp7.so
      echo "[Info]: copy /etc/httpd/modules/libphp7.so to /home/vagrant/.phpenv/versions/$PHP_VERSION/"
    fi

    sudo chown root:root /etc/httpd/modules
  fi

  if [[ -f $PHP_INI ]]; then
    sed -i -e "s/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" $PHP_INI
    sed -i -e "s/^display_errors = Off/display_errors = On/" $PHP_INI
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
    echo "[Info]: edit $PHP_INI"
  fi

  if [[ $OS_VERSION =~ ^6 ]]; then
    if [[ $PHP_FPM_ACTIVE == 0 ]]; then
      if [[ -f /tmp/php-build/source/$PHP_VERSION/sapi/fpm/init.d.php-fpm ]]; then
        sudo cp /tmp/php-build/source/$PHP_VERSION/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
        echo "[Info]: add init.d.php-fpm to /etc/init.d/"
        sudo chmod 755 /etc/init.d/php-fpm
      fi
    fi
  elif [[ $OS_VERSION =~ ^7 ]]; then
    if [[ -f /tmp/php-build/source/$PHP_VERSION/sapi/fpm/php-fpm.service ]]; then
      sudo cp /tmp/php-build/source/$PHP_VERSION/sapi/fpm/php-fpm.service $PHP_FPM_SERVICE
      sed -i -e "s/^PIDFile=\${prefix}\/var\/run\/php-fpm.pid/PIDFile=\/run\/php-fpm.pid/" $PHP_FPM_SERVICE
      sed -i -e "s/^ExecStart=\${exec_prefix}\/sbin\/php-fpm --nodaemonize --fpm-config \${prefix}\/etc\/php-fpm.conf/ExecStart=\/usr\/sbin\/php-fpm --nodaemonize --fpm-config \/home\/vagrant\/.phpenv\/versions\/$PHP_VERSION\/etc\/php-fpm.conf/" $PHP_FPM_SERVICE
      sed -i -e "8i EnvironmentFile=\/etc\/sysconfig\/php-fpm" $PHP_FPM_SERVICE
      sed -i -e "11i PrivateTmp=true" $PHP_FPM_SERVICE
      echo "[Info]: edit $PHP_FPM_SERVICE"
    fi

    if [[ ! -d /var/run/php-fpm ]]; then
      sudo mkdir /var/run/php-fpm
    fi
    if [[ -d /var/run/php-fpm ]]; then
      sudo chmod 755 /var/run/php-fpm
      sudo chown nobody:nobody /var/run/php-fpm
      echo "[Info]: add /var/run/php-fpm"
    fi
    if [[ ! -f /etc/sysconfig/php-fpm ]]; then
      sudo touch /etc/sysconfig/php-fpm
      sudo sh -c "echo '# Additional environment file for php-fpm' > /etc/sysconfig/php-fpm"
      echo "[Info]: add /etc/sysconfig/php-fpm"
    fi
    if [[ ! -f /etc/tmpfiles.d/php-fpm.conf ]]; then
      sudo touch /etc/tmpfiles.d/php-fpm.conf
      sudo sh -c "echo 'd /var/run/php-fpm 0775 nobody nobody' > /etc/tmpfiles.d/php-fpm.conf"
      echo "[Info]: add /etc/tmpfiles.d/php-fpm.conf"
    fi

    if [[ $PHP_FPM_ACTIVE == 0 ]]; then
      if [[ -f $PHP_FPM_SERVICE ]]; then
        sudo cp $PHP_FPM_SERVICE /usr/lib/systemd/system/php-fpm.service
        echo "[Info]: add php-fpm.service to /usr/lib/systemd/system/"
        sudo systemctl daemon-reload
      fi
    fi
  fi

  if [[ $PHP_FPM_ACTIVE == 0 ]]; then
    if [[ -f /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm ]]; then
      sudo cp /home/vagrant/.phpenv/versions/$PHP_VERSION/sbin/php-fpm /usr/sbin/php-fpm
      echo "[Info]: add php-fpm to /usr/sbin/"
      sudo chmod 755 /usr/sbin/php-fpm
    fi
  fi

  if [[ -f $PHP_FPM_CONF.default ]]; then
    sudo cp $PHP_FPM_CONF.default $PHP_FPM_CONF
    echo "[Info]: add php-fpm.conf"

    sed -i -e "s/^;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/" $PHP_FPM_CONF
    sed -i -e "s/^;error_log = log\/php-fpm.log/error_log = \/var\/log\/php-fpm\/error.log/" $PHP_FPM_CONF
    sed -i -e "s/^;daemonize = yes/daemonize = yes/" $PHP_FPM_CONF
    echo "[Info]: edit $PHP_FPM_CONF [global]"

    sed -i -e "s/^user = nobody/user = nobody/" $PHP_FPM_CONF
    sed -i -e "s/^group = nobody/group = nobody/" $PHP_FPM_CONF
    if [[ $OS_VERSION =~ ^7 ]]; then
      sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fcgi.pid/" $PHP_FPM_CONF
    fi
    sed -i -e "s/^;listen.owner = nobody/listen.owner = nobody/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.group = nobody/listen.group = nobody/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.mode = 0660/listen.mode = 0660/" $PHP_FPM_CONF
    sed -i -e "s/^;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/" $PHP_FPM_CONF
    echo "[Info]: edit $PHP_FPM_CONF [www]"
  fi

  if [[ -f $PHP_FPM_WWW_CONF.default ]]; then
    sudo cp $PHP_FPM_WWW_CONF.default $PHP_FPM_WWW_CONF
    echo "[Info]: add $PHP_FPM_WWW_CONF"

    sed -i -e "s/^user = nobody/user = nobody/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^group = nobody/group = nobody/" $PHP_FPM_WWW_CONF
    if [[ $OS_VERSION =~ ^7 ]]; then
      sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fcgi.pid/" $PHP_FPM_CONF
    fi
    sed -i -e "s/^;listen.owner = nobody/listen.owner = nobody/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.group = nobody/listen.group = nobody/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.mode = 0660/listen.mode = 0660/" $PHP_FPM_WWW_CONF
    sed -i -e "s/^;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/" $PHP_FPM_WWW_CONF
    echo "[Info]: edit $PHP_FPM_WWW_CONF"
  fi

  phpenv rehash
}

function remove() {
  if [[ -d /home/vagrant/.phpenv/versions/$PHP_VERSION ]]; then
    rm -rf /home/vagrant/.phpenv/versions/$PHP_VERSION
    echo "Remove PHP ${PHP_VERSION}"
  else
    echo "Cannot Remove PHP ${PHP_VERSION} (Not Found)"
  fi
}

if [ "$REMOVE" = "true" ]; then
  remove
  exit 0
fi

OS_VERSION=$(awk '{print $3}' /etc/*-release)
if [[ $OS_VERSION =~ ^release ]]; then
  OS_VERSION=$(awk '{print $4}' /etc/*-release)
fi

HTTPD_PHP_CONF="/etc/httpd/conf.d/php.conf"

if [ "$MODE" = "mod_php" ]; then
  if [[ ! -f "$HTTPD_PHP_CONF" ]]; then
    echo "[Error]: Make sure the specified php.conf is installed." >&2
    echo "[Error]: php.conf not found ${HTTPD_PHP_CONF}" >&2
    exit 1
  fi
fi

PHP_FPM_ACTIVE=`ps -ef | grep php-fpm.conf | grep -v grep | wc -l`
PHP_INI="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php.ini"
PHP_FPM_CONF="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.conf"
PHP_FPM_WWW_CONF="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.d/www.conf"
PHP_FPM_SERVICE="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.service"

if [[ -e /home/vagrant/.phpenv/versions/$PHP_VERSION ]]; then
  global
else
  install
  global
fi

exit 0
