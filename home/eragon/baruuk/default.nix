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

  monitors = [{
    name = "NV122WUM-N42";
    width = 1920;
    height = 1200;
    workspace = "1";
    primary = true;
  }];

}
