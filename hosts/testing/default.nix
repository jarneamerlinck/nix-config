{
  inputs,
  ...
}: {
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/optional/btrfs.nix
    ../common/disko/boot_1d_btrfs.nix

    ../common/base
    ../common/users/eragon

    ## Display server
    ../common/optional/wayland.nix
    ../common/optional/gtk.nix

    ## Display Managers
    ../common/optional/greetd.nix
    # ../common/optional/sddm.nix


    ## Desktop environments / Window Managers
    # ../common/optional/gnome.nix
    # ../common/optional/hyprland.nix



    ## Common items
    # ../common/optional/auto-rebuild.nix
    ../common/optional/unattended-upgrades.nix

    ../common/optional/pipewire.nix
    ../common/optional/virtualization/docker.nix

    ../common/optional/qemu-guest.nix
  ];

  networking = {
    hostName = "testing";
    useDHCP = true;
  };

  system.stateVersion = "24.11";
}
