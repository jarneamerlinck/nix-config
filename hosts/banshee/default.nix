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

    ## Common items
    # ../common/optional/auto-rebuild.nix
    ../common/optional/unattended-upgrades.nix

    ../common/optional/pipewire.nix
    ../common/optional/virtualization

    ../common/optional/qemu-guest.nix
  ];

  networking = {
    hostName = "banshee";
    useDHCP = true;
  };

  system.stateVersion = "24.05";
}
