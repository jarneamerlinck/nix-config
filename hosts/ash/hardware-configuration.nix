# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    loader = {
      grub = {
        efiSupport = false;
        efiInstallAsRemovable = false;
      };
      efi.canTouchEfiVariables = false;
    };
    initrd = {
      availableKernelModules = [
        "btrfs"         # Needed for btrfs storage
        # "ahci"          # Used for SATA (Advanced Host Controller Interface)
        "xhci_pci"      # Controller for USB (eXtensible Host Controller Interface)
        "usbhid"        # Needed for USB devices
        "usb_storage"   # For USB storage devices
        # "virtio_pci"    # PCI for virtio, only needed if VM is needed
        # "virtio_blk"    # Block for virtio, only needed if VM is needed
        # "sr_mod"        # Used for CD-ROM
      ];

      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  hardware.enableRedistributableFirmware = true;

}
