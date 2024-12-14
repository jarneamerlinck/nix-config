{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    ./features/other/git-config.nix
    ./features/cli/debugging.nix
    ./features/desktop/sway/minimalistic
    ./features/music
    ./features/cyber
    ./features/desktop/common/discord.nix
    ./features/desktop/common/matrix.nix
    ./features/desktop/common/vscode.nix
  ];
  wallpaper = pkgs.wallpapers.nixos-logo;

  colorScheme = inputs.nix-colors.colorSchemes.dracula;

  monitors = [{
    name = "eDP-1";
    width = 1600;
    height = 900;
    workspace = "1";
    primary = true;
  }];

}
