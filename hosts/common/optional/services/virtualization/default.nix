{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flatpak
  ];

  virtualisation.docker = {
    enable = true;
  };
}
