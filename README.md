# Nixos with flakes

## Deploy on current host

- run following command on a nixos host:

```bash
nix-shell https://github.com/jarneamerlinck/nix-config/tarball/main
```

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
|-- hosts                   <-- All configuration on host level
|   |-- common
|   |   |-- base            <-- base configuration for all hosts
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
3. Set root password and get IP
4. Test configuration (for host vm1)

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#vm1 --vm-test
```

5. Run the install commando from an other device with nix (change Ip and hostname)

```bash
nix run github:nix-community/nixos-anywhere -- --flake .#vm1 root@ip
```


## Create password hash

To create a password hash run the following command

```bash
mkpasswd -m sha-512
```


## Installation with minimal installer





### Create partitions

run all below in shell with `btrfs-progs`

```bash
nix-shell -p btrfs-progs neovim
```

1. Find the available drives to partition

The `-f` is needed to see the file systems on the drives.
(`sudo` is needed)


```bash
lsblk -f
```

2. Format the drives if there is still data on them

Fully shred files on `/dev/vda` with:

```bash
shred -v /dev/vda
```

For more important data use the following options:

```bash
shred -v --random-source=/dev/urandom -z -n 2 /dev/vda
```

This overwites them with random values and then with zero ( `-z`  )


3. Add disk partitions

Prep the disk for partitioning

```bash
printf "label: gpt\n,550M,U\n,,L\n" | sfdisk /dev/vda
```


Make a fat filesystem on `/dev/vda`

```bash
mkfs.fat -F 32 /dev/vda1
```
Make a btrfs filesystem on `/dev/vda`

```bash
mkfs.btrfs /dev/vda2 -L root
```

Mount `/dev/vda2` and partition


```bash
mount /dev/vda2 /mnt
```

Now create the subvolumes:

Also add `/mnt/home` if this is the only disk available.

```bash
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
```

If you want to add 1 partition to a drive use the following commands:

```bash
# mkfs.btrfs /dev/vdh
```

Create a home partition on a seperate disk:

```bash
mkfs.btrfs /dev/vdh -L home
mount /dev/vdh /mnt
btrfs subvolume create /mnt/home
umount /mnt
```



Now create a RAID 10 over 6 drives:

```bash
mkfs.btrfs -L data -d raid10 -m raid10 /dev/vdb /dev/vdc /dev/vdd /dev/vde /dev/vdf /dev/vdg
mount /dev/vdb /mnt
btrfs subvolume create /mnt/data
umount /mnt
```

A quick scan to make sure you registerd all of them:

```bash
btrfs device scan
```

### Mount for installation

> [!IMPORTANT]
> Make sure you replace the `/dev/vda` with the correct blocks.


```bash
mount -o compress=zstd,subvol=root /dev/vda2 /mnt
mkdir /mnt/{home,nix,data}
mount -o compress=zstd,subvol=home /dev/vdh /mnt/home
mount -o compress=zstd,subvol=data /dev/vdd /mnt/data
mount -o compress=zstd,noatime,subvol=nix /dev/vda2 /mnt/nix

mkdir /mnt/boot
mount /dev/vda1 /mnt/boot

```

### Install nixos

```bash
nixos-generate-config --root /mnt
```

Add mount points.

```bash
nvim /mnt/etc/nixos/configuration.nix
```

and add:

Validate in /


```nix
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/EB4F-1220";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/27d64343-8811-4f7b-a21e-b1f372af1030";
      fsType = "btrfs";
      options = [ "subvolume=root" "compress=zstd" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/9459b0d7-a65e-4af7-ae44-16ff389f0514";
      fsType = "btrfs";
      options = [ "subvolume=home" "compress=zstd" ];
    };

    "/data" = {
      device = "/dev/disk/by-uuid/d0a3e749-88cd-44d4-bd36-b173827b0f72";
      fsType = "btrfs";
      options = [ "subvolume=data" "compress=zstd" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/27d64343-8811-4f7b-a21e-b1f372af1030";
      fsType = "btrfs";
      options = [ "subvolume=nix" "compress=zstd" "noatime" ];
    };
  };
  boot.loader.grub.device = "/dev/disk/by-uuid/EB4F-1220";
  networking.hostName = "atlas";
  services.openssh.enable = true;
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" "/home" "/data"];
  };
```

Now run the installer:

```bash
nixos-install
```

This will ask for a root password at the end.

Enter the password and reboot.

the rest of the config can be loaded in when the system is running.
