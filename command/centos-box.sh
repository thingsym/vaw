#!/usr/bin/env bash

# usage: sudo /vagrant/command/centos-box.sh

set -e

ln -s -f /dev/null /etc/udev/rules.d/70-persistent-net.rules

rm -f /etc/sysconfig/network-scripts/ifcfg-eth1
rm -rf /dev/.udev/
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
rm -f /etc/udev/rules.d/70-persistent-ipoib.rules

du -sh /var/cache/yum
yum clean all

exit
