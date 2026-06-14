# Host

To setup a new host there are a few things you need to do:

1. [Prep host](./prep/host.md)
2. [Install host](./instalation/host.md)
2. [Post install](./post/host.md)


## Installation with minimal iso and nixos-anywhere

### Prep

> [!IMPORTANT]
> code below uses `vm1` as the example host

ensure the ssh keys have proper permissions

```bash
# Set the correct permissions so sshd will accept the key
chmod 600 "./ssh_host_ed25519_key"
```


1. Test configuration (to catch mistakes before pushing to host)

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#vm1 --vm-test
```
