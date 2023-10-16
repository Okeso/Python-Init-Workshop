
set -euf

rm -f /tmp/firecracker.socket

./firecracker --api-sock /tmp/firecracker.socket --config-file ./01-basics/vm_config.json
