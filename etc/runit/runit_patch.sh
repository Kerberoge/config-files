#!/bin/sh

# This script makes some small modifications to runit scripts, in order to customize
# their behavior to my liking.

# disable /var/log/dmesg.log
sed -i '/dmesg >\/var\/log\/dmesg.log/,+6d' /etc/runit/1

# modify PATH to include binaries in /usr/local/bin in service scripts
sed -i 's|PATH=/usr/bin:/usr/sbin|PATH=/usr/local/bin:/usr/bin|' /etc/runit/{1,2,3,ctrlaltdel}

# prevent the creation of useless directories
patch -d /etc/runit/core-services < emptydirs.patch
