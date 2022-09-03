
set -euf

rm -f /tmp/firecracker.socket

../firecracker --api-sock /tmp/firecracker.socket --config-file vm_config.json
