{
  inputs,
  ...
}:
{
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../features/disks/boot_btrfs_laptop.nix

    ../base
    ../base/users/eragon

    ## Display server
    ../features/desktop/wayland.nix
    ../features/desktop/gtk.nix

    ## Display Managers
    ../features/desktop/greetd.nix

    ## Desktop environments / Window Managers
    ../features/desktop/pipewire.nix

    ## Services items
    ../features/services/unattended-upgrades.nix

    ../features/virtualization/qemu/qemu-guest.nix
  ];

  networking = {
    hostName = "testing";
    useDHCP = true;
  };

  system.stateVersion = "25.05";
}
