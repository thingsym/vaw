#!/usr/bin/env bash

set -e

if [[ -d /vagrant/backup ]]; then
	echo "exist /vagrant/backup"
else
	mkdir /vagrant/backup
	echo "create /vagrant/backup"
fi

wp db export /vagrant/backup/backup-`date +%Y%m%d%H%M%S`.sql

exit
