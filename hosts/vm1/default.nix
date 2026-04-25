{
  imports = [

    ./hardware-configuration.nix

    ../features/disks/boot_1d_btrfs.nix

    ../base
    ../base/users/eragon

    ../features/disks/wd-decrypt.nix

    ## Display server
    ../features/desktop/wayland.nix
    ../features/desktop/gtk.nix

    ## Display Managers
    ../features/desktop/greetd.nix

    ## Desktop environments / Window Managers
    ../features/desktop/mouse.nix
    ../features/desktop/pipewire.nix

    ## Services items

    # ../features/virtualization/docker
    # ../features/virtualization/docker/traefik.nix
    # ../features/virtualization/docker/services/portainer.nix
    # ../features/virtualization/qemu/qemu-guest.nix

  ];
  services.resolved.enable = true;
  networking = {
    hostName = "vm1";
    useDHCP = false;
    firewall.enable = false;
    nameservers = [ ];
    # useNetworkd = true; # recommended for VLAN setups
    #
    vlans = {
      vlan11 = {
        id = 11;
        interface = "enp1s0";
      };
      vlan17 = {
        id = 17;
        interface = "enp1s0";
      };
    };
    dhcpcd.extraConfig = ''
      interface vlan17
        nogateway
    '';
    interfaces = {
      enp1s0 = {
        useDHCP = false;
        ipv4.addresses = [ ]; # ensure no IP
      };
      vlan11 = {
        useDHCP = true;
      };

      vlan17 = {
        # No IP assigned → stays L2 only
        useDHCP = false;
        ipv4.addresses = [ ]; # ensure no IP
      };
    };
  };

  system.stateVersion = "25.11";
}
