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

  networking.useNetworkd = true;

  networking.vlans = {
    vlan11 = {
      id = 11;
      interface = "enp7s0";
    };
    vlan18 = {
      id = 18;
      interface = "enp7s0";
    };
  };

  systemd.network.networks = {
    "vlan11" = {
      matchConfig.Name = "vlan11";
      networkConfig.DHCP = "ipv4";
    };

    "vlan18" = {
      matchConfig.Name = "vlan18";
      # networkConfig.DHCP = "ipv4";
      dhcpV4Config = {
        UseRoutes = false; # equivalent of ipv4.never-default
      };
    };
  };
  services.resolved.enable = true;
  networking.hostName = "vm1";

  system.stateVersion = "25.11";
}
