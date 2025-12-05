{ inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ../features/disks/boot_1d_btrfs.nix

    ../base
    ../base/users/eragon
    ../features/disks/wd-decrypt.nix

    ## Services items
    ../features/services/unattended-upgrades.nix
    ../features/virtualization/docker
    ../features/virtualization/docker/traefik.nix

  ];

  networking = {
    hostName = "banshee";
    useDHCP = true;
  };

  system.stateVersion = "25.11";
}
