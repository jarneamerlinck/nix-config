{ lib, pkgs,  ... }:
{
  imports = [
    ./common
    ./features/desktop/gnome
    ./features/music
    ./features/cyber
    ./features/cyber/extended.nix
  ];
  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1080;
    workspace = "1";
    primary = true;
  }];
}
