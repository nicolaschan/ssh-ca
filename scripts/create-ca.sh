#!/usr/bin/env bash
set -euo pipefail

ca_domain="$1"

if [[ "$ca_domain" == "" ]]; then
  echo "ca_domain is missing" >&2
  exit 1
fi

if [ -f pubkey.pem ]; then
  echo "pubkey.pem already exists" >&2
  exit 1
fi

if [ -f ssh-ca.pub ]; then
  echo "ssh-ca.pub already exists" >&2
  exit 1
fi

ykman piv keys generate --algorithm ECCP256 9a pubkey.pem
# to get this pem file again: ykman piv keys export 9a pubkey.pem
ykman piv certificates generate --subject "CN=$ca_domain SSH CA,O=$ca_domain" 9a pubkey.pem
ssh-keygen -i -m PKCS8 -f pubkey.pem > ssh-ca.pub
