{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../base
    ../features/desktop/sway/minimalistic

    # Apps
    ../features/applications/base
    ../features/applications/base/discord.nix
    ../features/applications/base/office.nix
    ../features/applications/base/media_player.nix
    ../features/applications/music
    ../features/applications/base/proton.nix
    ../features/applications/cyber/default.nix
    ../features/applications/cyber/exploration/nmap-desktop.nix
    ../features/applications/base/excalidraw_desktop_icon.nix
    ../features/desktop/common/swww.nix
  ];
  wallpaper-list = with pkgs.wallpapers; [
    framework-12-grid-16-10
  ];

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";

  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1200;
      workspace = "1";
      primary = true;
    }
  ];

}
