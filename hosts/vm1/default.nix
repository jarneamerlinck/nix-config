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

    ../common/disks/wd-decrypt.nix

    ## Display server
    ../common/desktop/wayland.nix
    ../common/desktop/gtk.nix

    ## Display Managers
    ../common/desktop/greetd.nix


    ## Desktop environments / Window Managers

    ## Common items
    ../common/optional/unattended-upgrades.nix

    ../common/desktop/pipewire.nix
    ../common/optional/virtualization/docker.nix
    ../common/optional/services/portainer.nix
    # ../common/optional/services/photos.nix


    ../common/desktop/mouse.nix
    ../common/desktop/wireshark.nix

    ../common/optional/qemu-guest.nix
  ];

  networking = {
    hostName = "vm1";
    useDHCP = true;
    nameservers = [ "1.1.1.1" ];
  };

  system.stateVersion = "24.11";
}
