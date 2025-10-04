{ lib, pkgs, ... }:
{
  imports = [
    ../base
    ../features/cli/tmux_saved_sessions.nix
    ../features/desktop/sway/minimalistic
    ../features/applications/cyber
  ];
  wallpaper = pkgs.wallpapers.nixos-logo;

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      workspace = "1";
      primary = true;
    }
  ];

}
