# ssh-ca

SSH Certificate Authority backed by a YubiKey.

## Setup

```bash
nix develop # or use direnv
```

## Usage

### Create a CA

```bash
create-ca example.com
```

Generates a new CA key in PIV slot 9a and outputs `ssh-ca.pub`.

### Sign a user key

```bash
sign-user-key alice ~/.ssh/id_ed25519.pub
```

Creates a certificate valid for 52 weeks.

This creates the certificate `~/.ssh/id_ed25519-cert.pub`. You may need to run `ssh-add` to add the certificate to your SSH agent:

```bash
ssh-add -l # see if your certificate is already loaded
ssh-add ~/.ssh/id_ed25519 # add the private key corresponding to the cert
ssh-add -l # see your certificate listed
```

### Sign a host key

```bash
sign-host-key server.example.com
```

Fetches the host key via SCP and signs it. Supports multiple hostnames:

```bash
sign-host-key server.example.com server server.local
```

## Client configuration

Add to `~/.ssh/known_hosts`:

```
@cert-authority *.example.com <contents of ssh-ca.pub>
```

## Server configuration

Add to `/etc/ssh/sshd_config`:

```
TrustedUserCAKeys /etc/ssh/ssh-ca.pub
HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub
```
