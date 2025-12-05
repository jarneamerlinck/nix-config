{ inputs, ... }:
{
  imports = [

    ./hardware-configuration.nix

    ../features/disks/boot_1d_btrfs.nix

    ../base
    ../base/users/eragon

    ../features/disks/wd-decrypt.nix

    ## Display server
    ../features/desktop/wayland.nix
    ../features/desktop/gtk.nix

    ## Display Managers
    ../features/desktop/greetd.nix

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

  networking = {
    hostName = "vm1";
    useDHCP = true;
    nameservers = [ "1.1.1.1" ];
  };

  system.stateVersion = "25.11";
}
