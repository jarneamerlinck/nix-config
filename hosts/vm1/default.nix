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
    ../common/desktop/mouse.nix
    ../common/desktop/pipewire.nix

    ## Services items
    ../common/services/unattended-upgrades.nix

    ../common/virtualization/docker
    ../common/services/portainer.nix
    ../common/virtualization/qemu/qemu-guest.nix

    ../common/desktop/wireshark.nix
  ];

  networking = {
    hostName = "vm1";
    useDHCP = true;
    nameservers = [ "1.1.1.1" ];
  };

  system.stateVersion = "25.05";
}
