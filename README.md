# Nixos with flakes

## Deploy on current host

- run following command on a nixos host:

```bash
nix-shell https://github.com/jarneamerlinck/nix-config/tarball/main
```

## Devices

| Hostname |      Board       |                  CPU                  |  RAM  |       Primary GPU       | Secondary GPU | Role  |  OS   | State |
| :------: | :--------------: | :-----------------------------------: | :---: | :---------------------: | :-----------: | :---: | :---: | :---: |
|  `ash`   | [Raspberry pi 4] |       [BCM2835 (4) @ 1.800GHz]        |  8GB  |                         |               |   🖥️  |   ❄️  |   ✅   |
|  `zima`  | [Zimaboard 832]  | [Intel Celeron N3450 (4) @ 2.200GHz ] |  8GB  | [Intel HD Graphics 500] |               |   🖥️  |   🐧 |   ✅   |
||
|  `vm1`   |                  |                                       |       |                         |               |   📦  |   ❄️  |   ✅   |


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
|       |   |   |-- hyprland
|       |   `-- nvim        <-- configuration for nvim (from the repo kickstart.nvim)
|       |-- ash.nix         <-- home-manager for host desktop1
|       |-- ssh.pub
|       `-- vm1.nix         <-- home-manager for host vm1
|-- hosts                   <-- All configuration on host level
|   |-- common
|   |   |-- base            <-- base configuration for all hosts
|   |   |-- optional        <-- optional configurations (like gnome, sddm, gdm, ...) on system level
|   |   `-- users           <-- configuration for each user (to call home-manager)
|   |       `-- eragon
|   |-- ash                 <-- configuration for the host desktop1
|   |   |-- default.nix
|   |   `-- hardware-configuration.nix
|   |-- vm1                 <-- configuration for the host vm1
|
|-- modules                 <-- modules for home-manager and nixos
|   |-- home-manager
|   `-- nixos
|-- overlays                <-- Overlays directory to be able to run pkgs
|
|-- pkgs                    <-- Custom packages
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
