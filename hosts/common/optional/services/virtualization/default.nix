{ config, pkgs, ... }:

{
  imports = [
    ./qemu.nix
    ./docker.nix
    ./wine.nix

  ];

  environment.systemPackages = with pkgs; [
    flatpak
    appimage-run
  ];

}
