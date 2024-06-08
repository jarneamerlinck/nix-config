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

    ../common/base
    ../common/users/eragon

    ../common/optional/xserver.nix
    # ../common/optional/gdm.nix

    # ../common/optional/auto-rebuild.nix
    ../common/optional/unattended-upgrades.nix
    ../common/optional/sddm.nix

    ../common/optional/pipewire.nix
    # ../common/optional/gnome.nix
    ../common/optional/hyprland.nix
    ../common/optional/services/virtualization

    # ../common/optional/qemu-guest.nix
  ];

  networking = {
    hostName = "vm1";
    useDHCP = true;
  };

  system.stateVersion = "23.11";
}
