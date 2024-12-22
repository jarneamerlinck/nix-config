{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    ./features/services/git-config.nix
    ./features/cli/debugging.nix
    ./features/desktop/sway/minimalistic
    ./features/music
    ./features/cyber
    ./features/cyber/pentesting
    ./features/cyber/exploration/wireshark.nix
    ./features/desktop/common/discord.nix
    ./features/desktop/common/vscode.nix
  ];
  wallpaper = pkgs.wallpapers.nixos-logo;

  colorScheme = inputs.nix-colors.colorSchemes.bright;

  monitors = [{
    name = "eDP-1";
    width = 1600;
    height = 900;
    workspace = "1";
    primary = true;
  }];

}
