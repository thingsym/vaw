#!/bin/bash
# Usage: phpenv.sh <Version Number|list|versions|version>

global() {
    phpenv global $VERSION

    if [[ $HTTPD_ACTIVE > 0 ]]; then
        sudo chown vagrant:vagrant /etc/httpd/conf.d/

        if [[ $VERSION =~ ^5 ]]; then
            sed -i -e "s/^#LoadModule php5_module/LoadModule php5_module/" $PHP_CONF
            sed -i -e "s/^LoadModule php7_module/#LoadModule php7_module/" $PHP_CONF
            sed -i -e "s/^#AddHandler php5-script/AddHandler php5-script/" $PHP_CONF
            sed -i -e "s/^AddHandler php7-script/#AddHandler php7-script/" $PHP_CONF
            echo "edit $PHP_CONF"
        elif [[ $VERSION =~ ^7 ]]; then
            sed -i -e "s/^LoadModule php5_module/#LoadModule php5_module/" $PHP_CONF
            sed -i -e "s/^#LoadModule php7_module/LoadModule php7_module/" $PHP_CONF
            sed -i -e "s/^AddHandler php5-script/#AddHandler php5-script/" $PHP_CONF
            sed -i -e "s/^#AddHandler php7-script/AddHandler php7-script/" $PHP_CONF
            echo "edit $PHP_CONF"
        fi

        sudo chown root:root /etc/httpd/conf.d/

        sudo chown vagrant:vagrant /etc/httpd/modules/libphp5.so
        phpenv apache-version $VERSION
        # sudo chown root:root /etc/httpd/modules/libphp5.so
    fi

    if [[ $PHP_FPM_ACTIVE > 0 ]]; then
        sudo service php-fpm stop
        sudo cp $PHP_FPM_CONF /home/vagrant/.phpenv/versions/$VERSION/etc/php-fpm.conf
        sudo cp /tmp/php-build/source/$VERSION/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
        sudo cp /home/vagrant/.phpenv/versions/$VERSION/sbin/php-fpm /usr/sbin/php-fpm
        sudo service php-fpm start
    fi

}

install() {
    if [[ $HTTPD_ACTIVE > 0 ]]; then
        sudo chown vagrant:vagrant /etc/httpd/modules
    fi

    phpenv install $VERSION /home/vagrant/.phpenv/versions/$VERSION

    if [[ $HTTPD_ACTIVE > 0 ]]; then
        if [[ $VERSION =~ ^5 ]]; then
            cp /etc/httpd/modules/libphp5.so /home/vagrant/.phpenv/versions/$VERSION/libphp5.so
        elif [[ $VERSION =~ ^7 ]]; then
            cp /etc/httpd/modules/libphp7.so /home/vagrant/.phpenv/versions/$VERSION/libphp7.so
        fi

        sudo chown root:root /etc/httpd/modules
    fi

    phpenv rehash

    global
}


if [ $# != 1 ]; then
    echo "Not Found php version"
    echo "Usage: phpenv.sh <Version Number|list|versions|version>"
    exit 1
fi

VERSION=$1

HTTPD_ACTIVE=`ps -ef | grep httpd | grep -v grep | wc -l`
PHP_FPM_ACTIVE=`ps -ef | grep php-fpm | grep -v grep | wc -l`

PHP_CONF='/etc/httpd/conf.d/php.conf'
PHP_FPM_CONF='/vagrant/roles/phpenv/templates/php-fpm.conf'

if [[ $HTTPD_ACTIVE > 0 ]]; then
    if [ ! -f "$PHP_CONF" ]; then
        echo "Make sure the specified php.conf is installed." >&2
        echo "php.conf not found ${PHP_CONF}" >&2
        exit 1
    fi
fi

if [ $VERSION == 'version' ]; then
    phpenv version
    exit 0
fi

if [ $VERSION == 'versions' ]; then
    phpenv versions
    exit 0
fi

if [ $VERSION == 'list' ]; then
    phpenv install
    exit 0
fi

if [ -e /home/vagrant/.phpenv/versions/$VERSION ]; then
    global
else
    install
fi

exit 0