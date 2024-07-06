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
    ./disko.nix

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
