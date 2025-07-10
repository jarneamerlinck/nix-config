{
  config,
  pkgs,
  lib,
  ...
}: let

  wallpaperListFile = "${config.xdg.configHome}/wallpaper_list.txt";
in
{
  wallpaper-list =  with pkgs.wallpapers; [
    framework-12-grid-16-10
    linkin-park-logo-4k-qu-16-10
    linkin-park-burning-in-the-skies-r1
    sunset-over-the-peaks-jx-16-10
    flare-lines-vr-16-10
    star-trails-5k-i0-16-10
    red-dragon-sky-16-10
  ];
  home.file."${wallpaperListFile}".text = lib.concatStringsSep "\n" (config.wallpaper-list);


  services.swww = {
    enable = true;
  };


  systemd.user.services.random-wallpaper = {
      Unit = {
        Description = "Set a random wallpaper from the configured list";
        After = [ "swww.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "set-random-wallpaper" ''
          set -eu
          if [ -s "$wallpaper_file" ]; then
            selected=$(shuf -n 1 "$wallpaper_file")
            ${pkgs.swww}/bin/swww img $(shuf -n 1 ${wallpaperListFile})
          else
            echo "Wallpaper list is empty or missing"
            exit 1
          fi
        '';
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

}
