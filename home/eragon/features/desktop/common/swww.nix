{
  config,
  pkgs,
  lib,
  ...
}: let

  cfg = config.wayland.windowManager.sway.config;
  wallpaperListFile = "${config.xdg.configHome}/wallpaper_list.txt";
in
{
  home.file."${wallpaperListFile}".text = lib.concatStringsSep "\n" (config.wallpaper-list);


  services.swww = {
    enable = true;
  };


  systemd.user.services.swww-random-wallpaper = {
      Unit = {
        Description = "Set a random wallpaper from the configured list";
        After = [ "swww.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "set-random-wallpaper" ''
          set -eu
          ${pkgs.swww}/bin/swww img $(${pkgs.coreutils}/bin/shuf -n 1 ${wallpaperListFile}) --transition-type=grow
        '';
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    wayland.windowManager.sway.config = rec {

      keybindings = {
        "${cfg.modifier}+Shift+w" = "exec systemctl --user restart swww-random-wallpaper";
        };
    };

}
