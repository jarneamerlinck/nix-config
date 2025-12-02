{ lib, pkgs, inputs, ... }: {
  imports = [
    ../base
    ../features/desktop/sway/minimalistic

    # Apps
    ../features/applications/base
    ../features/applications/base/discord.nix
    ../features/applications/base/office.nix
    ../features/applications/base/media_player.nix
    ../features/applications/base/image_editing.nix
    ../features/applications/base/hexecute.nix
    ../features/applications/music
    ../features/applications/base/proton.nix
    ../features/applications/cyber/default.nix
    ../features/applications/cyber/analysis
    ../features/applications/cyber/exploration/nmap-desktop.nix
    ../features/applications/base/excalidraw_desktop_icon.nix
  ];

  # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
  stylix.image = "${pkgs.wallpapers.star-trails-5k-i0-16-10}";

  monitors = [
    {
      name = "BOE NV122WUM-N42 Unknown";
      width = 1920;
      height = 1200;
      workspace = "1";
      primary = true;
      x = 0;
      y = 0;
    }
    {
      name = "Microstep MAG 27CQ6F CD9M275204513";
      width = 2560;
      height = 1600;
      refreshRate = 144;
      workspace = "2";
      primary = false;
      x = 1920;
      y = 0;
    }
    {
      name = "Microstep MAG 27CQ6F CD9M275203628";
      width = 2560;
      height = 1600;
      refreshRate = 144;
      workspace = "3";
      primary = false;
      x = 1920 + 2560;
      y = 0;
    }
  ];

}
