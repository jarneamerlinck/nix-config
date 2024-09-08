{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [

# https://github.com/tiredofit/nixos-config/blob/da4b765d8d496e821828d173705fcef010dae10f/deploy-templates/disko/efi-btrfs-swap-raid1.nix
# https://github.com/nix-community/disko/issues/543
#https://github.com/elliottminns/dotfiles/blob/2985327b3fbd1d127df9cf0acb1e7b09a88b44ba/nix/machines/amaterasu/disko-config-raid.nix#L3
#https://github.com/tiredofit/nixos-config/blob/dc03fb4a210e4e3f033952391b4049b1f1d23811/deploy-templates/disko/efi-btrfs-swap-raid1.nix#L6
#https://github.com/josephst/nixfiles/blob/48cd155c9779f535836e74ef54ad3bf55c753557/hosts/nixos/terminus/disko-hdd-storage.nix#L4
#https://github.com/kaldyr/nixos/blob/8c8aa3ccbb7d64e9b2559eee3329f981ce871e60/systems/magrathea.nix#L84
#https://github.com/budimanjojo/nix-config/blob/4d77edbe58a499c151352d592f1a561176ddef22/system/hosts/budimanjojo-nas/disk-config.nix#L64
#https://github.com/tiredofit/nixos-config/blob/dc03fb4a210e4e3f033952391b4049b1f1d23811/deploy-templates/disko/efi-luks-btrfs-impermanence-swap-raid1.nix#L7

    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    # For the raid 10 as it's not supported by disko we need to add the other disks to the system after the installer is done

    # ../common/disko/raid_btrfs.nix
    ../common/optional/btrfs.nix
    ../common/disko/boot_custom_nas.nix


    # ../common/disko/boot_custom_nas.nix

    ../common/base
    ../common/users/eragon

    ## Display server
    ../common/optional/xserver.nix
    ../common/optional/wayland.nix

    ## Display Managers
    ../common/optional/greetd.nix
    # ../common/optional/sddm.nix


    ## Desktop environments / Window Managers
    # ../common/optional/gnome.nix
    # ../common/optional/hyprland.nix



    ## Common items
    # ../common/optional/auto-rebuild.nix
    ../common/optional/unattended-upgrades.nix

    ../common/optional/pipewire.nix
    ../common/optional/services/virtualization

    ../common/optional/qemu-guest.nix
  ];

  networking = {
    hostName = "atlas";
    useDHCP = true;
  };

  system.stateVersion = "24.05";
}
