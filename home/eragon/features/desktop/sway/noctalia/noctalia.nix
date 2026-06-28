{ config, ... }:
{
  # configure options
  wayland.windowManager.sway.systemd.extraCommands = [
    "noctalia"
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = false;
    settings = {
      # configure noctalia here
      desktop_widgets.enabled = false;
      idle.pre_action_fade_seconds = 0;
      dock.enabled = false;
      general = {
        avatarImage = "/home/${config.home.username}/.face";
        radiusRatio = 0.2;
      };
      location.auto_locate = true;
      lockscreen_widgets.enable = false;
      theme.source = "community";
      wallpaper.enabled = false;
      bar = {

        density = "compact";
        position = "top";
        showCapsule = false;
        widgets = {
          center = [
            {

              id = "clock";
            }
            {

              id = "date";
            }
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
            {
              id = "workspaces";
            }
          ];
          left = [
            {

              id = "ControlCenter";
              useDistroLogo = true;
            }
            {

              id = "Network";
            }
            {

              id = "Bluetooth";
            }

            {

              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 20;
            }
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
    };
  };
}
