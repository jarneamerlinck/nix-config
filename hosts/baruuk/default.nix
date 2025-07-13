{
  inputs,
  lib,
  ...
}: {
  imports = [

    inputs.hardware.nixosModules.framework-12-13th-gen-intel
    ./hardware-configuration.nix
    ../common/disks/boot_1d_btrfs.nix
    ../common/base/timezone.nix

    ../common/base
    ../common/users/eragon
    ../common/disks/wd-decrypt.nix
    ../common/desktop/wireless.nix

    ## Services items
    ../common/virtualization/docker
    ../common/services/excalidraw.nix
    ../common/services/unattended-upgrades.nix
    # ../common/services/wireguard_client.nix

    ## Display server
    ../common/desktop/wayland.nix
    ../common/desktop/gtk.nix

    ## Display Managers
    ../common/desktop/greetd.nix


    ## Desktop environments / Window Managers
    ../common/desktop/mouse.nix
    ../common/desktop/pipewire.nix
  ];

  networking = {
    hostName = "baruuk";
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = "25.05";
}
