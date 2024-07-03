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

    ../common/optional/unattended-upgrades.nix

    ../common/optional/pipewire.nix
    ../common/optional/services/virtualization/docker.nix
  ];

  networking = {
    hostName = "ash";
    useDHCP = true;
  };

  system.stateVersion = "24.05";
}
