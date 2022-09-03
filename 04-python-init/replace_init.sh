set -euf

#cp hello-rootfs.ext4.orig hello-rootfs.ext4
mkdir -p /mnt/vm
mount rootfs.ext4 /mnt/vm
chmod +x init-custom.sh
chmod +x init-python.py
cp init-custom.sh /mnt/vm/sbin/init
cp init-python.py /mnt/vm/sbin/init-python.py
umount /mnt/vm
