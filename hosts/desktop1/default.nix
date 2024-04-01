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

    # ../common/optional/ckb-next.nix
    # ../common/optional/greetd.nix
    # ../common/optional/pipewire.nix
    # ../common/optional/quietboot.nix
    # ../common/optional/lol-acfix.nix
    # ../common/optional/starcitizen-fixes.nix
  ];

  networking = {
    hostName = "desktop1";
    useDHCP = true;
  };

  system.stateVersion = "23.05";
}
