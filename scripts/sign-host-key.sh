#!/usr/bin/env bash
set -euo pipefail

keyfile=""

# Parse optional -f flag for keyfile
while getopts "f:" opt; do
    case $opt in
        f) keyfile="$OPTARG";;
        *) echo "Usage: $0 [-f keyfile] hostname1 [hostname2 ...]"; exit 1;;
    esac
done
shift $((OPTIND - 1))

# Check if at least one hostname is provided
if [ $# -eq 0 ]; then
    echo "Error: No hostnames provided"
    echo "Usage: $0 [-f keyfile] hostname1 [hostname2 ...]"
    exit 1
fi

first_host="$1"
all_hosts=$(IFS=,; echo "$*")

# If no keyfile provided, fetch from remote host
if [ -z "$keyfile" ]; then
    scp "$first_host":/etc/ssh/ssh_host_ed25519_key.pub hostkey.pub
    keyfile="hostkey.pub"
fi

ssh-keygen -D "$PKCS11_PROVIDER" -s ssh-ca.pub -I "$first_host" -h -n "$all_hosts" -V +520w "$keyfile"
