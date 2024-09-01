{ lib, pkgs,  ... }:
{
  imports = [
    ./common
    ./features/desktop/sway/minimalistic
    ./features/cyber
  ];
  wallpaper = pkgs.wallpapers.nixos-logo;

  monitors = [{
    name = "eDP-1";
    width = 1600;
    height = 900;
    workspace = "1";
    primary = true;
  }];

}
