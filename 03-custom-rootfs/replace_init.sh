set -euf

#cp hello-rootfs.ext4.orig hello-rootfs.ext4
mkdir -p /mnt/vm
mount rootfs.ext4 /mnt/vm
chmod +x init-custom.sh
cp init-custom.sh /mnt/vm/sbin/init
umount /mnt/vm
