{
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ../common/disks/boot_1d_btrfs.nix

    ../common/base
    ../common/users/eragon
    ../common/disks/wd-decrypt.nix

    ## Services items
    ../common/services/unattended-upgrades.nix
    ../common/virtualization/docker
    ../common/services/cloudflare_tunnel.nix

  ];

  networking = {
    hostName = "banshee";
    useDHCP = true;
  };

  system.stateVersion = "24.11";
}
