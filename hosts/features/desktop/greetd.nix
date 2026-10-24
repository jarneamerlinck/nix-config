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

  services.displayManager.regreet = {
    enable = true;

    settings = {
      # Specifies the default command to execute upon logging in
      commands = {
        default = "de-session";
      };
    };
  };
  systemd.tmpfiles.rules = [
    ''f+ /var/lib/regreet/state.toml 0644 greeter greeter - {"last_user":"","last_session":"de-session"}''
  ];
  # services.greetd = {
  #   enable = false;
  #   settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --asterisks --user-menu --cmd de-session";
  # };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Cage launches ReGreet as a single-app Wayland compositor
        command = "${pkgs.coreutils}/bin/env XKB_DEFAULT_LAYOUT=be ${pkgs.cage}/bin/cage -s -mlast -- ${config.services.displayManager.regreet.package}/bin/regreet";
        user = "greeter";
      };
    };
  };

}
