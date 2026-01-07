#!/usr/bin/env bash
set -euo pipefail

# Check if at least one hostname is provided
if [ $# -eq 0 ]; then
    echo "Error: No hostnames provided"
    echo "Usage: $0 hostname1 [hostname2 ...]"
    exit 1
fi

first_host="$1"
all_hosts=$(IFS=,; echo "$*")

scp "$first_host":/etc/ssh/ssh_host_ed25519_key.pub hostkey.pub

ssh-keygen -D "$PKCS11_PROVIDER" -s ssh-ca.pub -I "$first_host" -h -n "$all_hosts" -V +520w hostkey.pub
