{
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [

    ./hardware-configuration.nix

    ../features/disks/boot_1d_btrfs.nix

    outputs.nixosModules.base
    outputs.nixosModules.desktop

    # ../base/users/eragon

    # ../features/disks/wd-decrypt.nix

    ## Display Managers

    ## Desktop environments / Window Managers
    ../features/desktop/mouse.nix
    ../features/desktop/pipewire.nix

    ## Services items
    ../features/services/unattended-upgrades.nix

    ../features/virtualization/docker
    ../features/virtualization/docker/traefik.nix
    ../features/virtualization/docker/services/portainer.nix
    ../features/virtualization/qemu/qemu-guest.nix

    ../features/desktop/wireshark.nix
  ];
  base.networking.hostname = "vm1";
  desktop = {
    enable = false;
  };

}
