{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [


    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    # For the raid 10 as it's not supported by disko we need to add the other disks to the system after the installer is done

    # ../common/disko/raid_btrfs.nix
    ../common/optional/btrfs.nix
    ../common/disko/boot_custom_nas.nix


    # ../common/disko/boot_custom_nas.nix

    ../common/base
    ../common/users/eragon
    ../common/optional/wd-decrypt.nix

    ## Display server
    ../common/optional/xserver.nix
    ../common/optional/wayland.nix

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
    ../common/optional/virtualization

    ../common/optional/services/cloudflare_tunnel.nix
    ../common/optional/services/homebox.nix
    ../common/optional/services/syncthing.nix
    ../common/optional/services/rss_feed.nix
    ../common/optional/services/portainer.nix
    ../common/optional/services/zabbix_server.nix
    ../common/optional/services/zabbix_client.nix
    # ../common/optional/services/zabbix_web.nix

    ../common/optional/services/music.nix

    # ../common/optional/qemu-guest.nix
  ];

  networking = {
    hostName = "atlas";
    useDHCP = true;
  };

  system.stateVersion = "24.05";
}
