{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    flatpak
    appimage-run
  ];

}
