# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];
  boot = {
    loader.grub = {
      enable = true;
      device = "/dev/vda";
      useOSProber = true;
    };
    initrd = {
      availableKernelModules = [
        "btrfs"         # Needed for btrfs storage
        "ahci"          # Used for SATA (Advanced Host Controller Interface)
        "xhci_pci"      # Controller for USB (eXtensible Host Controller Interface)
        "usbhid"        # Needed for USB devices
        "usb_storage"   # For USB storage devices
        "virtio_pci"    # PCI for virtio, only needed if VM is needed
        "virtio_blk"    # Block for virtio, only needed if VM is needed
        "sr_mod"        # Used for CD-ROM
      ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/561d7879-2de3-49c7-b647-f6153dbe2e6f";
      fsType = "ext4";
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
