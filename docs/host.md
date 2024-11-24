# Host

## Add new host

1. Make a new folder under ´./hosts´

    1. Generate a ssh key for the new host

    or get it from a vault (see [nixos-anywhere vaults](https://nix-community.github.io/nixos-anywhere/howtos/secrets.html#example-decrypting-an-openssh-host-key-with-pass))

    `ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C root@vm1`

    2. Put the ssh key in the following folder structure on the host

    `"$temp/etc/ssh/ssh_host_ed25519_key"`

    3. Set the correct permissions for the host

2. Copy the harware config and adjust

3. Create a new file under `/home/username`

## Installation with minimal iso and nixos-anywhere

### Prep

> [!IMPORTANT]
> code below uses `vm1` as the example host

ensure the ssh keys have proper permissions

```bash
# Set the correct permissions so sshd will accept the key
chmod 600 "./ssh_host_ed25519_key"
```

### Instalation

1. Boot live installer
2. Check disks and adapt the config

    ```bash
    lsblk -f
    ```

3. Set nixos password and get IP

    ```bash
    passwd
    ip -a 
    ```

4. Test configuration (to catch mistakes before pushing to host)

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#vm1 --vm-test
```

5. Run the install commando from an other device with nix (change Ip and hostname)

```bash
nix run github:nix-community/nixos-anywhere -- --extra-files "$temp" --flake .#vm1 nixos@ip
```

(without extra temp files)

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#vm1 nixos@ip
```

## Deploy on current host

- run following command on a nixos host:

```bash
nix-shell https://github.com/jarneamerlinck/nix-config/tarball/main
```

