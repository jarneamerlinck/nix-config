{ pkgs, lib, config, ... }:
let
  session = if config.wayland.windowManager.hyprland.enable then "Hyprland"
            else if config.wayland.windowManager.sway.enable then "sway"
            else "sway";  # default fallback

in
{
  services.greetd = {
      enable = true;
      settings = {
       default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd ${session}
      '';
      };
    };

    environment.etc."greetd/environments".text = ''
      ${session}
    '';
}
