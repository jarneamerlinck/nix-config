{ config, lib, ... }:
{
  wayland.windowManager.sway.systemd.extraCommands = [
    "noctalia"
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = false;

    settings = {
      desktop_widgets.enabled = false;

      idle.pre_action_fade_seconds = 0;

      dock = {
        background_opacity = 1.0;
        enabled = false;
      };

      location.auto_locate = true;

      lockscreen = {
        enabled = false;
      };

      nightlight = {
        enabled = true;
      };

      notification = {
        background_opacity = 1.0;
      };

      osd = {
        background_opacity = 1.0;
      };

      shell = {
        font_family = lib.mkForce config.stylix.fonts.monospace.name;
        avatar_path = "/home/${config.home.username}/.face";
      };

      theme = lib.mkForce {
        custom_palette = "stylix";
        mode = "dark";
        source = lib.mkForce "community";
      };

      wallpaper = {
        enabled = false;

      };

      bar = {
        density = "compact";
        position = "top";
        showCapsule = false;

        widgets = {
          center = [
            "date"
            "clock"
          ];

          end = [
            "media"
            "tray"
            "notifications"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "control-center"
            "session"
          ];

          shadow = false;

          start = [
            "workspaces"
          ];

        };
      };

      control_center.shortcuts = [
        {
          type = "wifi";
        }

        {
          type = "bluetooth";
        }

        {
          type = "nightlight";
        }

        {
          type = "power_profile";
        }
      ];
      widget.date.format = "{:%H:%M  %a %d %b}";
    };
  };
}
