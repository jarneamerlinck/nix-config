{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flatpak
    qemu
    distrobox

    quickemu
    virt-manager
  ];
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  # programs.virt-manager.enable = true; # for 23.11 or after

  virtualisation.docker = {
    enable = true;
  };

}
