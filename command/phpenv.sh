#!/bin/bash
# Usage: phpenv.sh <Version Number|list|versions|version>

global() {
    phpenv global $PHP_VERSION

    if [[ $HTTPD_ACTIVE > 0 ]]; then
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
    fi

    if [[ $PHP_FPM_ACTIVE > 0 ]]; then
        if [[ $OS_VERSION =~ ^6 ]]; then
            sudo service php-fpm stop

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

            sudo service php-fpm start
        elif [[ $OS_VERSION =~ ^7 ]]; then
            sudo systemctl stop php-fpm

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

            sudo systemctl start php-fpm
        fi
    fi
}

install() {
    if [[ -d /etc/httpd/modules ]]; then
        sudo chown vagrant:vagrant /etc/httpd/modules
    fi

    phpenv install $PHP_VERSION /home/vagrant/.phpenv/versions/$PHP_VERSION

    if [[ -d /etc/httpd/modules ]]; then
        if [[ -f /etc/httpd/modules/libphp5.so ]]; then
            cp /etc/httpd/modules/libphp5.so /home/vagrant/.phpenv/versions/$PHP_VERSION/libphp5.so
        fi

        if [[ -f /etc/httpd/modules/libphp7.so ]]; then
            cp /etc/httpd/modules/libphp7.so /home/vagrant/.phpenv/versions/$PHP_VERSION/libphp7.so
        fi

        sudo chown root:root /etc/httpd/modules
    fi

    if [[ -f $PHP_INI ]]; then
        sed -i -e "s/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL/" $PHP_INI
        sed -i -e "s/^display_errors = Off/display_errors = On/" $PHP_INI
        sed -i -e "s/^post_max_size = 8M/post_max_size = 36M/" $PHP_INI
        sed -i -e "s/^upload_max_filesize = 2M/upload_max_filesize = 36M/" $PHP_INI
        sed -i -e "s/^;mbstring.language = Japanese/mbstring.language = neutral/" $PHP_INI
        sed -i -e "s/^;mbstring.internal_encoding =/mbstring.internal_encoding = UTF-8/" $PHP_INI
        sed -i -e "s/^;date.timezone =/date.timezone = UTC/" $PHP_INI
        sed -i -e 's/^;session.save_path = \"\/tmp\"/session.save_path = \"\/tmp\"/' $PHP_INI

        sed -i -e "s/^;opcache.memory_consumption=64/opcache.memory_consumption=128/" $PHP_INI
        sed -i -e "s/^;opcache.interned_strings_buffer=4/opcache.interned_strings_buffer=8/" $PHP_INI
        sed -i -e "s/^;opcache.max_accelerated_files=2000/opcache.max_accelerated_files=4000/" $PHP_INI
        sed -i -e "s/^;opcache.revalidate_freq=2/opcache.revalidate_freq=60/" $PHP_INI
        sed -i -e "s/^;opcache.fast_shutdown=0/opcache.fast_shutdown=1/" $PHP_INI
        # sed -i -e "s/^;opcache.enable_cli=0/opcache.enable_cli=1/" $PHP_INI
        # sed -i -e "s/^;opcache.enable=0/opcache.enable=1/" $PHP_INI
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
            sudo chmod 755 /var/run/php-fpm
            HAS_NGINX_USER=`cat /etc/passwd | grep nginx | grep -v grep | wc -l`
            if [[ $HAS_NGINX_USER > 0 ]]; then
                sudo chown nginx:nginx /var/run/php-fpm
            fi
            echo "[Info]: add /var/run/php-fpm"
        fi
        if [[ ! -f /etc/sysconfig/php-fpm ]]; then
            sudo touch /etc/sysconfig/php-fpm
            sudo sh -c "echo '# Additional environment file for php-fpm' > /etc/sysconfig/php-fpm"
            echo "[Info]: add /etc/sysconfig/php-fpm"
        fi
        if [[ ! -f /etc/tmpfiles.d/php-fpm.conf ]]; then
            sudo touch /etc/tmpfiles.d/php-fpm.conf
            sudo sh -c "echo 'd /var/run/php-fpm 0775 nginx nginx' > /etc/tmpfiles.d/php-fpm.conf"
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

        sed -i -e "s/^user = nobody/user = nginx/" $PHP_FPM_CONF
        sed -i -e "s/^group = nobody/group = nginx/" $PHP_FPM_CONF
        sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fcgi.pid/" $PHP_FPM_CONF
        sed -i -e "s/^;listen.owner = nobody/listen.owner = nginx/" $PHP_FPM_CONF
        sed -i -e "s/^;listen.group = nobody/listen.group = nginx/" $PHP_FPM_CONF
        sed -i -e "s/^;listen.mode = 0660/listen.mode = 0660/" $PHP_FPM_CONF
        sed -i -e "s/^;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/" $PHP_FPM_CONF
        echo "[Info]: edit $PHP_FPM_CONF [www]"
    fi

    if [[ -f $PHP_FPM_WWW_CONF.default ]]; then
        sudo cp $PHP_FPM_WWW_CONF.default $PHP_FPM_WWW_CONF
        echo "[Info]: add $PHP_FPM_WWW_CONF"

        sed -i -e "s/^user = nobody/user = nginx/" $PHP_FPM_WWW_CONF
        sed -i -e "s/^group = nobody/group = nginx/" $PHP_FPM_WWW_CONF
        sed -i -e "s/^listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fcgi.pid/" $PHP_FPM_WWW_CONF
        sed -i -e "s/^;listen.owner = nobody/listen.owner = nginx/" $PHP_FPM_WWW_CONF
        sed -i -e "s/^;listen.group = nobody/listen.group = nginx/" $PHP_FPM_WWW_CONF
        sed -i -e "s/^;listen.mode = 0660/listen.mode = 0660/" $PHP_FPM_WWW_CONF
        sed -i -e "s/^;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 127.0.0.1/" $PHP_FPM_WWW_CONF
        echo "[Info]: edit $PHP_FPM_WWW_CONF"
    fi

    phpenv rehash
}


if [[ $# != 1 ]]; then
    echo "[Error]: Not Found php version"
    echo "[Info]: Usage: phpenv.sh <Version Number|list|versions|version>"
    exit 1
fi

PHP_VERSION=$1

OS_VERSION=$(awk '{print $3}' /etc/*-release)
if [[ $OS_VERSION =~ ^release ]]; then
    OS_VERSION=$(awk '{print $4}' /etc/*-release)
fi

HTTPD_ACTIVE=`ps -ef | grep httpd | grep -v grep | wc -l`
PHP_FPM_ACTIVE=`ps -ef | grep php-fpm | grep -v grep | wc -l`

HTTPD_PHP_CONF="/etc/httpd/conf.d/php.conf"
PHP_INI="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php.ini"
PHP_FPM_CONF="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.conf"
PHP_FPM_WWW_CONF="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.d/www.conf"
PHP_FPM_SERVICE="/home/vagrant/.phpenv/versions/$PHP_VERSION/etc/php-fpm.service"

if [[ $HTTPD_ACTIVE > 0 ]]; then
    if [[ ! -f "$HTTPD_PHP_CONF" ]]; then
        echo "[Error]: Make sure the specified php.conf is installed." >&2
        echo "[Error]: php.conf not found ${HTTPD_PHP_CONF}" >&2
        exit 1
    fi
fi

if [[ $PHP_VERSION == 'version' ]]; then
    phpenv version
    exit 0
fi

if [[ $PHP_VERSION == 'versions' ]]; then
    phpenv versions
    exit 0
fi

if [[ $PHP_VERSION == 'list' ]]; then
    phpenv install -l
    exit 0
fi

if [[ -e /home/vagrant/.phpenv/versions/$PHP_VERSION ]]; then
    global
else
    install
    global
fi

exit 0