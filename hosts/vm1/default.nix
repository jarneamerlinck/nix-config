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

  networking = {
    hostName = "vm1";
    useDHCP = true;

    # networking.useNetworkd = true; # recommended for VLAN setups
    #
    # networking.vlans = {
    #   vlan11 = {
    #     id = 11;
    #     interface = "enp1s0";
    #   };
    #   vlan17 = {
    #     id = 17;
    #     interface = "enp1s0";
    #   };
    # };
    #
    # networking.interfaces = {
    #   vlan11 = {
    #     useDHCP = true;
    #   };
    #
    #   vlan17 = {
    #     # No IP assigned → stays L2 only
    #   };
    # };
  };

  system.stateVersion = "25.11";
}
