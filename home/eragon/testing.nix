{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    ./features/cli/debugging.nix
    ./features/desktop/sway/minimalistic
    ./features/desktop/applications/openlens.nix
    ./features/music
    ./features/cyber
  ];
  wallpaper = pkgs.wallpapers.nixos-logo;

  colorScheme = inputs.nix-colors.colorSchemes.brewer;

  monitors = [{
    name = "eDP-1";
    width = 1600;
    height = 900;
    workspace = "1";
    primary = true;
  }];

}
