#!/bin/sh

umount /mnt/vm
rm ./rootfs.ext4

set -euf

# Create a 1GB partition
dd if=/dev/zero of=rootfs.ext4 bs=1MB count=1000
mkfs.ext4 rootfs.ext4
mount rootfs.ext4 /mnt/vm

# Allow non-root to use Firecracker on this filesystem
chmod 666 rootfs.ext4

echo "Copying Debian Bullseye minimal"
cp -pr ./rootfs/. /mnt/vm

chroot /mnt/vm /bin/sh <<EOT

set -euf

# Install Debian Packages
apt-get install -y --no-install-recommends --no-install-suggests \
  python3 python3-dev python3-pip \
  openssh-server

pip3 install --upgrade pip

# Set up a login terminal on the serial console (ttyS0):"
ln -s agetty /etc/init.d/agetty.ttyS0
echo ttyS0 > /etc/securetty
EOT


cat <<EOT > ./rootfs/etc/inittab
# /etc/inittab

::sysinit:/sbin/init sysinit
::sysinit:/sbin/init boot
::wait:/sbin/init default

# Set up a couple of getty's
tty1::respawn:/sbin/getty 38400 tty1
tty2::respawn:/sbin/getty 38400 tty2
tty3::respawn:/sbin/getty 38400 tty3
tty4::respawn:/sbin/getty 38400 tty4
tty5::respawn:/sbin/getty 38400 tty5
tty6::respawn:/sbin/getty 38400 tty6

# Put a getty on the serial port
ttyS0::respawn:/sbin/getty -L ttyS0 115200 vt100

# Stuff to do for the 3-finger salute
::ctrlaltdel:/sbin/reboot

# Stuff to do before rebooting
::shutdown:/sbin/init shutdown
EOT


# Custom init
chmod +x init-custom.sh
chmod +x init-python.py
cp init-custom.sh /mnt/vm/sbin/init
cp init-python.py /mnt/vm/sbin/init-python

umount /mnt/vm

