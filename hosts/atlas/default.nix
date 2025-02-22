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
    # ../common/optional/auto-rebuild.nix
    ../common/optional/unattended-upgrades.nix

    ../common/desktop/pipewire.nix
    ../common/optional/virtualization/docker.nix
    ../common/optional/virtualization/qemu.nix
    ../common/optional/virtualization/wine.nix

    # ../common/optional/services/ddns.nix
    ../common/optional/services/cloudflare_tunnel.nix
    ../common/optional/services/homebox.nix
    ../common/optional/services/syncthing.nix
    ../common/optional/services/rss_feed.nix
    ../common/optional/services/portainer.nix
    ../common/optional/services/zabbix_server.nix
    ../common/optional/services/zabbix_client.nix
    # ../common/optional/services/zabbix_web.nix

    ../common/optional/services/calibre.nix
    ../common/optional/services/music.nix
    # ../common/optional/services/recipes.nix
    ../common/optional/services/photos.nix
    # ../common/optional/services/drawio.nix

    # smart tools
    ../common/optional/services/search.nix

  ];

  networking = {
    hostName = "atlas";
    useDHCP = true;
  };

  system.stateVersion = "24.11";
}
