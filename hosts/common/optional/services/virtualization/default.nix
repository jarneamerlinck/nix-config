{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flatpak
    qemu
    distrobox

    quickemu
  ];

  virtualisation.docker = {
    enable = true;
  };

}
