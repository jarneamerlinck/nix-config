{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    ./features/cli/tmux_saved_sessions.nix
    ./features/desktop/sway/minimalistic

    # Apps
    ./features/desktop/applications
    ./features/desktop/applications/discord.nix
    ./features/desktop/applications/office.nix
    ./features/desktop/applications/media_player.nix
    ./features/music
    ./features/desktop/applications/proton.nix
    ./features/cyber/default.nix
    ./features/cyber/exploration/nmap-desktop.nix
    ./features/desktop/common/swww.nix
  ];
  # wallpaper = pkgs.wallpapers.framework-12-grid;
  wallpaper-list =  with pkgs.wallpapers; [
    framework-12-grid-16-10
    # linkin-park-logo-4k-qu-16-10
    # linkin-park-burning-in-the-skies-r1
    # sunset-over-the-peaks-jx-16-10
    flare-lines-vr-16-10
    # rotating-waves-gif
    # red-dragon-gif
    astronaut-red-moon-gif
    # glowing-abstract-flow-gif
    gothic-floral-skull-gif
    # meteor-shower-apocalypse-gif
    # space-black-hole-gif
    # lone-samurai-silhouette-gif
    # giant-sun-falls-gif
    # colorful-matrix-code-gif
    # disturbed-gif



  ];

  colorScheme = inputs.nix-colors.colorSchemes.equilibrium-dark;

  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1200;
    workspace = "1";
    primary = true;
  }];

}

