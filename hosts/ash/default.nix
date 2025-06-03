{
  inputs,
  ...
}: {
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/disks/boot_1d_btrfs.nix

    ../common/base
    ../common/users/eragon

    ../common/virtualization/docker
  ];

  networking = {
    hostName = "ash";
    useDHCP = true;
  };

  system.stateVersion = "25.05";
}
