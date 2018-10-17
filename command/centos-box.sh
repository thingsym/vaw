#!/usr/bin/env bash

# usage: sudo /vagrant/command/centos-box.sh

set -e

ln -s -f /dev/null /etc/udev/rules.d/70-persistent-net.rules

rm -f /etc/sysconfig/network-scripts/ifcfg-eth1
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
rm -f /etc/udev/rules.d/70-persistent-ipoib.rules

rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# du -sh /var/cache/yum
# yum clean all

find /var/log -type f | while read f; do echo -ne '' > $f; done;

dd if=/dev/zero of=/EMPTY bs=1M || echo 'complete!! writes zeroes to all empty space on the volume';
rm -f /EMPTY;

exit 0
