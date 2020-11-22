#!/bin/bash

dnf install -y epel-release bzip2 &&
dnf install -y dkms &&
mount /dev/sr1 /mnt &&
cd /mnt &&
./VBoxLinuxAdditions.run || exit 1
reboot
