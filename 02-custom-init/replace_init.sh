set -euf

#cp hello-rootfs.ext4.orig hello-rootfs.ext4
mkdir -p /mnt/vm
mount hello-rootfs.ext4 /mnt/vm
chmod +x myinit.sh
cp myinit.sh /mnt/vm/sbin/init
umount /mnt/vm
