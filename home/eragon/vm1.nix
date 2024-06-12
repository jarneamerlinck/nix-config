{ lib, pkgs,  ... }:
{
  imports = [
    ./common
    ./features/desktop/sway
    ./features/music
    ./features/cyber
    ./features/cyber/extended.nix
  ];
  monitors = [{
    name = "eDP-1";
    width = 1600;
    height = 900;
    workspace = "1";
    primary = true;
  }];
}
