#!/bin/bash

#clean build directories
rm -rf linux-5.9.9*

#clean unnecessary  packages
dnf history rollback -y $(dnf history list -3 | tail -n1 | awk '{print $1}') &&
dnf erase -y $(rpm -qa | grep kernel) &&
dnf clean all || exit 1


# Install vagrant default key
mkdir -pm 700 /home/vagrant/.ssh &&
curl -sL https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys &&
chmod 0600 /home/vagrant/.ssh/authorized_keys &&
chown -R vagrant:vagrant /home/vagrant/.ssh || exit 1


# Remove temporary files
rm -rf /tmp/*
rm  -f /var/log/wtmp /var/log/btmp
rm -rf /var/cache/* /usr/share/doc/*
rm -rf /var/cache/dnf
rm -rf /vagrant/home/*.iso
rm -rf /root/linux-*
rm  -f ~/.bash_history
history -c || exit 1

rm -rf /run/log/journal/*

# Fill zeros all empty space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync || exit 1
