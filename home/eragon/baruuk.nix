{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    ./features/desktop/sway/minimalistic

    # Apps
    ./features/desktop/applications
    ./features/desktop/applications/discord.nix
    ./features/desktop/applications/office.nix
    ./features/desktop/applications/media_player.nix
    ./features/music
  ];
  wallpaper = pkgs.wallpapers.framework-12-grid;

  colorScheme = inputs.nix-colors.colorSchemes.equilibrium-dark;

  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1200;
    workspace = "1";
    primary = true;
  }];

}

