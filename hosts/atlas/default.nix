{
  inputs,
  ...
}: {
  imports = [


    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    # For the raid 10 as it's not supported by disko we need to add the other disks to the system after the installer is done

    ../common/disks/boot_custom_nas.nix


    # ../common/disko/boot_custom_nas.nix

    ../common/base
    ../common/users/eragon
    ../common/disks/wd-decrypt.nix

    ## Display server
    ../common/desktop/xserver.nix
    ../common/desktop/wayland.nix

    ## Display Managers
    ../common/desktop/greetd.nix


    ## Desktop environments / Window Managers

    ## Common items
    ../common/services/unattended-upgrades.nix

    ../common/desktop/pipewire.nix
    ../common/optional/virtualization/docker.nix
    ../common/optional/virtualization/qemu.nix
    ../common/optional/virtualization/wine.nix

    # ../common/services/ddns.nix
    ../common/services/cloudflare_tunnel.nix
    ../common/services/homebox.nix
    ../common/services/syncthing.nix
    ../common/services/rss_feed.nix
    ../common/services/portainer.nix
    ../common/services/zabbix_server.nix
    ../common/services/zabbix_client.nix
    # ../common/services/zabbix_web.nix

    ../common/services/calibre.nix
    ../common/services/music.nix
    # ../common/services/recipes.nix
    ../common/services/photos.nix
    # ../common/services/drawio.nix

    # smart tools
    ../common/services/search.nix

  ];

  networking = {
    hostName = "atlas";
    useDHCP = true;
  };

  system.stateVersion = "24.11";
}
