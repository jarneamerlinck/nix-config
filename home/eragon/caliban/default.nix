{
  pkgs,
  inputs,
  ...
}:
let
  p_monitor_scale = 1.5;
in
{
  imports = [
    ../base
    ../features/desktop/sway/noctalia
    ../features/cli/aws.nix

    # Apps
    ../features/applications/base
    ../features/applications/base/discord.nix
    ../features/applications/base/office.nix
    ../features/applications/base/media_player.nix
    ../features/applications/base/image_editing.nix
    ../features/applications/base/obsidian.nix
    ../features/applications/music
    ../features/applications/base/proton.nix
    ../features/applications/base/dolphin.nix
    ../features/applications/cyber/default.nix
    ../features/applications/cyber/analysis
    ../features/applications/cyber/exploration/nmap-desktop.nix
    ../features/applications/games/prism-launcher.nix
  ];

  stylix.image = "${pkgs.wallpapers.fw13p-pixelart-hand-3-2}";
  home.pointerCursor.enable = true;
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  monitors = [
    {
      name = "China Star Optoelectronics Technology Co., Ltd MND508ZB1-1 Unknown";
      width = 2880;
      height = 1920;
      workspace = "1";
      primary = true;
      refreshRate = 120;
      x = 0;
      y = 0;
      scale = p_monitor_scale;
    }
    {
      name = "Microstep MAG 27CQ6F CD9M275204513";
      width = 2560;
      height = 1600;
      refreshRate = 144;
      workspace = "2";
      primary = false;
      x = builtins.floor (2880 / p_monitor_scale);
      y = 0;
    }
    {
      name = "Microstep MAG 27CQ6F CD9M275203628";
      width = 2560;
      height = 1600;
      refreshRate = 144;
      workspace = "3";
      primary = false;
      x = builtins.floor (2880 / p_monitor_scale + 2560);
      y = 0;
    }
  ];

}
