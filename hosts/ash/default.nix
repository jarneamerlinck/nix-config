{ inputs, ... }: {
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ../features/disks/boot_1d_btrfs.nix

    ../base
    ../base/users/eragon

    ../features/virtualization/docker
    ../features/virtualization/docker/traefik.nix
  ];

  networking = {
    hostName = "ash";
    useDHCP = true;
  };

  system.stateVersion = "25.11";
}
