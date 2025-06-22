{ inputs, lib, pkgs, config, outputs, ... }:
let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  i_modifier = "Mod4";
in
{
  imports = [
    ../../common
    ../../common/wayland-common.nix
  ];
  home.sessionVariables = {
    TERMINAL = "kitty";
    XCURSOR_SIZE = 24;
    HYPRCURSOR_SIZE = 24;
    mainMod = "SUPER";
  };


  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "${toString monitor.name}, ${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}, auto, auto"
      ];
      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";



      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        col = {
          active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          inactive_border = "rgba(595959aa)";
        };
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        rounding_power = 2;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };

      input = {
        kb_layout = "be";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      keyBinds = [
        "$mainMod, T, exec, kitty"
        "$mainMod, E, exec, dolphin"
        "$mainMod, R, exec, wofi --show drun"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, 1, workspace, 1"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        # Add more as needed
      ];

    };
    extraConfig = ''
    '';
  };
}
