#!/bin/sh

set -euf

rm -fr ./rootfs
mkdir ./rootfs

echo "Downloading Debian Bullseye minimal"
debootstrap --variant=minbase bullseye ./rootfs http://deb.debian.org/debian/

