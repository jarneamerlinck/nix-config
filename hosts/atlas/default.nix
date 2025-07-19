{
  inputs,
  ...
}:
{
  imports = [

    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    # For the raid 10 as it's not supported by disko we need to add the other disks to the system after the installer is done

    ../features/disks/boot_custom_nas.nix

    # ../common/disko/boot_custom_nas.nix

    ../base
    ../base/users/eragon
    ../features/disks/wd-decrypt.nix

    ## Display server
    ../features/desktop/xserver.nix
    ../features/desktop/wayland.nix

    ## Display Managers
    ../features/desktop/greetd.nix

    ## Desktop environments / Window Managers
    ../features/desktop/pipewire.nix

    ## Services items
    ../features/services/unattended-upgrades.nix

    ../features/virtualization/docker
    ../features/virtualization/docker/traefik.nix
    ../features/virtualization/qemu
    ../features/virtualization/wine

    ../features/virtualization/docker/services/cloudflare_tunnel.nix
    ../features/virtualization/docker/services/homebox.nix
    ../features/virtualization/docker/services/syncthing.nix
    ../features/virtualization/docker/services/rss_feed.nix
    ../features/virtualization/docker/services/portainer.nix

    ../features/virtualization/docker/services/calibre.nix
    ../features/virtualization/docker/services/music.nix
    ../features/virtualization/docker/services/photos.nix

    # smart tools
    ../features/virtualization/docker/services/search.nix

  ];

  networking = {
    hostName = "atlas";
    useDHCP = true;
  };

  system.stateVersion = "25.05";
}
