{
  inputs,
  lib,
  outputs,
  ...
}:
{
  imports = [

    inputs.hardware.nixosModules.framework-12-13th-gen-intel
    outputs.nixosModules.base
    outputs.nixosModules.hardware
    ./hardware-configuration.nix
    ../features/disks/boot_btrfs_laptop.nix

    ../base/timezone.nix

    ../base
    ../base/users/eragon
    ../base/networking.nix
    ../features/disks/wd-decrypt.nix
    ../features/desktop/wireless.nix
    ../features/desktop/hexecute.nix

    ## Services items
    ../features/virtualization/incus
    ../features/virtualization/docker
    ../features/virtualization/docker/services/excalidraw.nix
    ../features/services/unattended-upgrades.nix

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

  base.networking.hostname = "baruuk";
  base.networking.dhcp = lib.mkDefault true;
  harware.laptop = true;
}
