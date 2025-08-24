{
  inputs,
  lib,
  ...
}:
{
  imports = [

    inputs.hardware.nixosModules.framework-12-13th-gen-intel
    ./hardware-configuration.nix
    ../features/disks/boot_btrfs_laptop.nix

    ../base/timezone.nix

    ../base
    ../base/users/eragon
    ../features/disks/wd-decrypt.nix
    ../features/desktop/wireless.nix

    ## Services items
    ../features/virtualization/docker
    ../features/virtualization/docker/services/excalidraw.nix
    ../features/services/unattended-upgrades.nix

    ../features/services/google_coral.nix

    ## Display server
    ../features/desktop/wayland.nix
    ../features/desktop/gtk.nix

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

  system.stateVersion = "25.05";
}
