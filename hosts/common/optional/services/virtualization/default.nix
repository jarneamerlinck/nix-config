{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flatpak
    qemu
    distrobox

    quickemu
  ];
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.docker = {
    enable = true;
  };

}
