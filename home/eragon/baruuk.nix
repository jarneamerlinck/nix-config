{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    # ./features/desktop/sway/minimalistic
  ];
  # wallpaper = pkgs.wallpapers.framework-12-grid;
  #
  # colorScheme = inputs.nix-colors.colorSchemes.equilibrium-dark;
  #
  # monitors = [{
  #   name = "eDP-1";
  #   width = 1920;
  #   height = 1200;
  #   workspace = "1";
  #   primary = true;
  # }];

}

