# Instalation: Host

## 0. Validate if config builds

Before starting the live boot and so on you can validate if the build for the new host has any build errors.

```bash
nh os build -H hostname .
```

Or with nixos-anywhere

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#hostname --vm-test
```

## 1. Live boot host to install

### Flash iso to usb

Get iso [nixos.org](https://nixos.org/download/#nixos-iso)

```bash
sudo dd bs=4M conv=fsync oflag=direct status=progress if=<path-to-image> of=/dev/sdX
```

### Live boot

1. Set password and get IP.

    ```bash
    passwd
    ip a
    ```

2. Check disks and adapt the config

    ```bash
    lsblk -f
    ```

## 2. Nixos anywhere

On another computer you'll need

- ssh keys
- disk encryption key
- nix flake to push to host

Add `$TEMP` and validate content

```bash
export TEMP=~/Documents/back/ssh-keys/baruuk
tree -p $TEMP
```

The output should be

```text
├── [-rw-rw-r--]  disk.key
└── [drwxr-xr-x]  etc
    └── [drwxr-xr-x]  ssh
        ├── [-rw-------]  ssh_host_ed25519_key
        └── [-rw-r--r--]  ssh_host_ed25519_key.pub
```


> Start installation

```bash
nix run github:nix-community/nixos-anywhere -- --extra-files "$TEMP" --disk-encryption-keys /tmp/disk.key <(cat "$TEMP/disk.key") --flake .#hostname  nixos@10.20.0.133
```

After the nixos anywhere has completed the live boot will automaticly reboot

## 3. New host after reboot
### Luks + tmp2 (Only if required)


```bash
sudo systemd-cryptenroll --wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=0 /dev/disk/by-id/nvme-WD_BLACK_SN770M_1TB_000000000000-part4
```

### Create folders for age keys

```bash
mkdir -p ~/.config/sops/age
```

## 4. Copy ssh/age keys to host

Next you'll need to copy the ssh pub and priv key to the host for the correct user.
Same for the age key

- ssh (~/.ssh)

    ```text
    [drwx------]  .ssh
    ├── [-rw-r--r--]  authorized_keys
    ├── [lrwxrwxrwx]  config -> /nix/store/9lwp57aw2ac7j1yjygga9aq5zd67mkzd-home-manager-files/.ssh/config
    ├── [-rw-------]  id_ed25519
    ├── [-rw-r--r--]  id_ed25519.pub
    ```
- age (~/.config/sops/age/keys.txt)

    ```text
    [drwxr-xr-x]  .config/sops/age
    └── [-rw-r--r--]  keys.txt
    ```

## 5. Clone repo and rebuild

Clone this repo and rebuild it

```bash
git clone git@github.com:jarneamerlinck/nix-config.git ~/nix-config
cd nix-config
# git checkout feature/new-host
```

Rebuild host

```bash
rebuildf
```
