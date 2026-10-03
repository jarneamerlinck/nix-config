{ inputs, lib, ... }:
{
  imports = [
    inputs.hardware.nixosModules.framework-intel-core-ultra-series3
    ./hardware-configuration.nix
    ../features/hardware/laptop.nix
    ../features/hardware/keychron.nix
    ../features/disks/boot_btrfs_laptop.nix

    ../base/timezone.nix

    ../base
    ../base/users/eragon
    ../features/disks/wd-decrypt.nix
    ../features/desktop/wireless.nix
    ../features/desktop/flatpak.nix
    ../features/services/printing.nix
    ../features/services/finger_print.nix

    ## Services items
    ../features/virtualization/qemu
    ../features/virtualization/docker
    ../features/services/protonmail_bridge.nix

    ../features/services/games
    ../features/services/obs-studio.nix

    ../features/services/google_coral.nix
    ../features/services/wireguard_client.nix

    ## Display server
    ../features/desktop/wayland.nix
    ../features/desktop/gtk.nix
    ../features/desktop/krita.nix

    ## Display Managers
    ../features/desktop/greetd.nix

    ## Desktop environments / Window Managers
    ../features/desktop/mouse.nix
    ../features/desktop/pipewire.nix
  ];
  networking = {
    hostName = "caliban";
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = "26.05";
}
