# Nixos with flakes


## Devices

| Hostname  |      Board       |                  CPU                  |  RAM  |       Primary GPU       | Secondary GPU | Role  |  OS   | State |
| :-------: | :--------------: | :-----------------------------------: | :---: | :---------------------: | :-----------: | :---: | :---: | :---: |
|  `ash`    | [Raspberry pi 4] |       [BCM2835 (4) @ 1.800GHz]        |  8GB  |                         |               |   🖥️  |   ❄️  |   ✅   |
|  `zima`   | [Zimaboard 832]  | [Intel Celeron N3450 (4) @ 2.200GHz ] |  8GB  | [Intel HD Graphics 500] |               |   🖥️  |   🐧 |   ✅   |
||
|  `vm1`    |                  |                                       |       |                         |               |   📦  |   ❄️  |   ✅   |
|  `atlas`  |                  |                                       |       |                         |               |   📦  |   ❄️  |   ✅   |


Virtual machine: 📦
Linux: 🐧
NixOS: ❄️
Desktop: 🖥️
Laptop: 💻️

## Directory structure

```
|-- home                    <-- home-manager configuration for each user
|   `-- eragon              <-- home-manager for user eragon
|       |-- common          <-- default configuration for cli
|       |-- features
|       |   |-- cli         <-- configuration for all cli related tools
|       |   |-- desktop     <-- user configuration for desktop tools
|       |   |   |-- common
|       |   |   |-- gnome
|       |   |   |-- sway
|       |   `-- nvim        <-- configuration for nvim (from the repo kickstart.nvim)
|       |-- ash.nix         <-- home-manager for host ash
|       |-- ssh.pub
|       `-- vm1.nix         <-- home-manager for host vm1
|
|-- hosts                   <-- all configuration on host level
|   |-- common
|   |   |-- base            <-- base configuration for all hosts
|   |   |-- disko           <-- disko configs to set disk partitions on nix-anywhere install
|   |   |-- optional        <-- optional configurations (like gnome, sddm, gdm, ...) on system level
|   |   `-- users           <-- configuration for each user (to call home-manager)
|   |       `-- eragon
|   |-- ash                 <-- configuration for the host ash
|   |   |-- default.nix
|   |   `-- hardware-configuration.nix
|   |-- vm1                 <-- configuration for the host vm1
|
|-- modules                 <-- modules for home-manager and nixos
|   |-- home-manager
|   `-- nixos
|
|-- overlays/               <-- Overlays to modify pkgs
|
|-- pkgs                    <-- Custom packages
|   `-- wallpapers          <-- Package for custom wallpapers
|
|-- default.nix             <-- Nix dev file to be able to run the flake
|-- deploy.sh               <-- Shell file to run the flake and update the system
|-- flake.lock              <-- Version lock for the flake
|-- flake.nix               <-- Nix file for the flake
`-- README.md               <-- This README
```

## Add a new host

1. Make a new folder under ´./hosts´
2. Copy the harware config and adjust
3. Create a new file under `/home/username`

## Desktops

- desktops can be changed in ´hosts/{hostname}/default.nix´

## Usefull commands

### Cleaning up space

```bash
nix-store --gc
nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"

sudo nix-collect-garbage --delete-older-than 20d
```

## Installation with minimal iso and nixos-anywhere

1. Boot live installer
2. Check disks and adapt the config
3. Set nixos password and get IP
4. Test configuration (for host vm1)

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#vm1 --vm-test
```

5. Run the install commando from an other device with nix (change Ip and hostname)

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#vm1 nixos@ip
```

### RAID

As btrfs raid 10 is not supported from just disko run the following command after running btrfs

add disk `/dev/sdd` to `/data`

```bash
btrfs device add /dev/sdd /data
```

and after you have added all the disks run

```bash
btrfs balance start -v -dconvert=raid10,soft /data
```

## Build iso and attach shell to it

- select another user if you want to test the ssh connection

```bash
QEMU_NET_OPTS="hostfwd=tcp::2222-:22" nix --impure run github:nix-community/nixos-anywhere -- --flake .#vm1 --vm-test

ssh -p 2222 eragon@localhost

```


## Create password hash

To create a password hash run the following command

```bash
mkpasswd -m sha-512
```



## Deploy on current host

- run following command on a nixos host:

```bash
nix-shell https://github.com/jarneamerlinck/nix-config/tarball/main
```


## Troubleshooting

### RAID root disk is gone

mount -o degraded,usebackuproot /data



## Quick tips
### Snapper on btrfs

Snapper is used for snapshotting and recovery.

see [snapper](https://github.com/jarneamerlinck/cheatsheet/blob/main/linux/snapper.md) for more info.
