{ pkgs, ... }:
# let
#   homeCfgs = config.home-manager.users;
#   homeSharePaths = lib.mapAttrsToList (_: v: "${v.home.path}/share") homeCfgs;
#   vars = ''XDG_DATA_DIRS="$XDG_DATA_DIRS:${lib.concatStringsSep ":" homeSharePaths}" GTK_USE_PORTAL=0'';
#
#   # misterioCfg = homeCfgs.misterio;
#   # gtkTheme = misterioCfg.gtk.theme;
#   # iconTheme = misterioCfg.gtk.iconTheme;
#   # wallpaper = misterioCfg.wallpaper;
#
#   # sway-kiosk = command: "${lib.getExe pkgs.sway} --config ${pkgs.writeText "kiosk.config" ''
#   #   output * bg #000000 solid_color
#   #   xwayland disable
#   #   input "type:touchpad" {
#   #     tap enabled
#   #   }
#   #   exec '${vars} ${command}; ${pkgs.sway}/bin/swaymsg exit'
#   # ''}";
# in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd "/home/\$USER/.nix-profile/bin/greetd-session"
      '';
    };
  };
}
