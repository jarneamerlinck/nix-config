{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/optional/btrfs.nix
    ../common/disko/boot_1d_btrfs.nix

    ../common/base
    ../common/users/eragon

    ../common/optional/wireless.nix
    ../common/optional/wd-decrypt.nix
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
    ../common/optional/virtualization
    # ../common/optional/services/calibre.nix

    ../common/optional/services/portainer.nix
    ../common/optional/qemu-guest.nix
  ];

  networking = {
    hostName = "vm1";
    useDHCP = true;
    nameservers = [ "1.1.1.1" ];
  };

  system.stateVersion = "24.11";
}
