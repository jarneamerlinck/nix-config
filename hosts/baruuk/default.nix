{
  inputs,
  ...
}: {
  imports = [

    inputs.hardware.nixosModules.framework-12-13th-gen-intel
    ./hardware-configuration.nix
    ../common/disks/boot_1d_btrfs.nix

    ../common/base
    ../common/users/eragon
    ../common/disks/wd-decrypt.nix

    ## Services items
    ../common/services/unattended-upgrades.nix

  ];

  networking = {
    hostName = "baruuk";
    useDHCP = true;
  };

  system.stateVersion = "25.05";
}
