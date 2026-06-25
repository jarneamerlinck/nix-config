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
    ../features/virtualization/docker/services/hawser.nix

  ];

  networking = {
    hostName = "banshee";
    useDHCP = true;
  };

  system.stateVersion = "26.05";
}
