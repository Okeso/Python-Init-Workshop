# Additional steps to make the init behave nicely

## 1. Clean shutdown to avoid Kernel panic 

Send reboot syscall, see man page
https://man7.org/linux/man-pages/man2/reboot.2.html

```python

print("Unmounting system filesystems")
system("umount /dev/shm")
system("umount /dev/pts")
system("umount -a")

libc = ctypes.CDLL(None)
libc.syscall(169, 0xFEE1DEAD, 672274793, 0x4321FEDC, None)

# The exit should not happen due to system halt.
sys.exit(0)
```

## 2. Additional volumes

You can give your VM access to additional volumes, even other partitions on your disks.

1. Create a new partition. See `04-python-init/setup_rootfs.sh` for an example to create an ext4 partition.
2. Update the `vm_config.json` file to add the new volume. Try making it read-only or read-write.

## 3. Setup networking

Give network access to the virtual machine using the Firecracker Network Setup instructions.

https://github.com/firecracker-microvm/firecracker/blob/main/docs/network-setup.md

1. Configure networking on the host
2. Update the `vm_config.json` file to add a network interface
3. Update your Python init to configure the network inside the virtual machine

## 4. Use VSOCK

Implement network-independent communication between the virtual machine (your Python init) and a process running on the host system using `VSOCK` sockets

> The VSOCK address family facilitates communication between virtual machines and the host they are running on.  This address family is used by guest agents and hypervisor services that need a communications channel that is independent of virtual machine network configuration.

The following documentation from the Firecracker project will help you achieving this:

https://github.com/firecracker-microvm/firecracker/blob/main/docs/vsock.md

1. Setup the networking in the virtual machine using configuration passed by the host instead of being hardcoded in the filesystem.


