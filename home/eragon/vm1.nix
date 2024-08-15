{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    ./features/cli/debugging.nix
    ./features/desktop/sway/minimalistic
    ./features/music
    ./features/cyber
    ./features/cyber/extended.nix
  ];
  wallpaper = lib.mkDefault pkgs.wallpapers.nixos-logo;

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  monitors = [{
    name = "eDP-1";
    width = 1600;
    height = 900;
    workspace = "1";
    primary = true;
  }];

}
