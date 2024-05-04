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
    # inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/base
    ../common/users/eragon

    # ../common/optional/auto-rebuild.nix
    ../common/optional/unattended-upgrades.nix

    ../common/optional/pipewire.nix
    ../common/optional/services/virtualization/docker.nix

    ../common/optional/compose2nix.nix
  ];

  networking = {
    hostName = "ash";
    useDHCP = true;
  };

  system.stateVersion = "23.05";
}
