#!/bin/bash

#Install ncessary tools to build the kernel
dnf install -y wget make gcc flex bison openssl-devel bc elfutils-libelf-devel perl tar  &&
#Download kernel
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.9.9.tar.xz &&
#Extract kernel
tar -xf linux-5.9.9.tar.xz &&
#Change to the downloaded kernel directory
cd linux-5.9.9 &&
#Copy config from running kernel
cp /boot/config-$(uname -r) .config &&
#Configure kernel with thw config from running kernel
make olddefconfig &&
#Allow kernel to be builded with self-signed key + disable DEBUG to reduce free space necessary for the build
./scripts/config --disable DEBUG_INFO --disable CONFIG_DEBUG_INFO_DWARF4 --set-str CONFIG_SYSTEM_TRUSTED_KEYS "" &&
#Build kernel - was builded on 6 physical core CPU
make -j24 &&
#Install kernel+module
make modules_install &&
make install || exit 1
reboot
