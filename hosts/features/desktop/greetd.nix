{ pkgs, config, ... }:
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
    settings.default_session.command = "${pkgs.qtgreet}/bin/qtgreet --time --asterisks --user-menu --cmd de-session";
  };

  systemd.tmpfiles.rules = [
    ''f+ /var/lib/regreet/state.toml 0644 greeter greeter - {"last_user":"","last_session":"de-session"}''
  ];
}
