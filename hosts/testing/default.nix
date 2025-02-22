{
  inputs,
  ...
}: {
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/disks/boot_1d_btrfs.nix

    ../common/base
    ../common/users/eragon

    ## Display server
    ../common/desktop/wayland.nix
    ../common/desktop/gtk.nix

    ## Display Managers
    ../common/desktop/greetd.nix


    ## Desktop environments / Window Managers

    ## Common items
    ../common/services/unattended-upgrades.nix

    ../common/desktop/pipewire.nix
    ../common/optional/virtualization/kubernetes/single_node.nix

    # ../common/optional/openlens.nix
    ../common/optional/qemu-guest.nix
  ];

  networking = {
    hostName = "testing";
    useDHCP = true;
  };

  system.stateVersion = "24.11";
}
