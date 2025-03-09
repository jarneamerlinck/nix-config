{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    ./features/cli/debugging.nix
    ./features/desktop/sway/minimalistic
    ./features/cyber
    ./features/desktop/applications/lens.nix
  ];
  wallpaper = pkgs.wallpapers.abstract-cubes;

  colorScheme = inputs.nix-colors.colorSchemes.equilibrium-dark;

  monitors = [{
    name = "eDP-1";
    width = 1600;
    height = 900;
    workspace = "1";
    primary = true;
  }];

}
