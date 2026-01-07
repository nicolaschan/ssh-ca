#!/usr/bin/env bash
set -euo pipefail

username="$1"
pubkey="$2"
hostname="$(hostname)"

if [[ "$username" == "" ]]; then
  echo "username is missing" >&2
  exit 1
fi

if [[ "$pubkey" == "" ]]; then
  echo "pubkey file is missing" >&2
  exit 1
fi

if [ ! -f ssh-ca.pub ]; then
  echo "ssh-ca.pub missing; create ca first" >&2
  exit 1
fi

ssh-keygen -D "$PKCS11_PROVIDER" -s ssh-ca.pub -I "$username@$hostname" -n "$username" -V +52w "$pubkey"
