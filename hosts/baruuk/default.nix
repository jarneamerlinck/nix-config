{ inputs, lib, ... }:
{
  imports = [
    inputs.hardware.nixosModules.framework-12-13th-gen-intel
    ./hardware-configuration.nix
    ../features/hardware/laptop.nix
    ../features/hardware/keychron.nix
    ../features/disks/boot_btrfs_laptop.nix

    ../base/timezone.nix

    ../base
    ../base/users/eragon
    ../features/disks/wd-decrypt.nix
    ../features/desktop/wireless.nix
    ../features/hardware/switcher_tablet_mode.nix
    # ../features/desktop/hexecute.nix

    ## Services items
    ../features/virtualization/qemu
    ../features/virtualization/docker
    ../features/virtualization/docker/services/excalidash_local.nix
    ../features/services/unattended-upgrades.nix

    ../features/services/games
    ../features/services/obs-studio.nix

    ../features/services/google_coral.nix
    # ../features/services/wireguard_client.nix

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
    hostName = "baruuk";
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = "26.05";
}
