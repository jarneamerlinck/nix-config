{ config, ... }:
{
  # configure options
  wayland.windowManager.sway.systemd.extraCommands = [
    "noctalia-shell"
  ];
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = false;
    settings = {
      # configure noctalia here
      bar = {
        density = "compact";
        position = "top";
        showCapsule = false;
        widgets = {
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
          ];
          center = [
            {
              hideUnoccupied = false;
              id = "Workspace";
              labelMode = "none";
            }
          ];
          right = [
            {
              alwaysShowPercentage = false;
              id = "Battery";
              warningThreshold = 30;
            }
            {
              formatHorizontal = "HH:mm";
              formatVertical = "HH mm";
              id = "Clock";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
          ];
        };
      };
      dock.enabled = false;
      wallpaper.enabled = false;
      general = {
        avatarImage = "/home/${config.home.username}/.face";
        radiusRatio = 0.2;
      };
      location = {
        monthBeforeDay = false;
        name = "Brussels, Belgium";
      };
    };
    # this may also be a string or a path to a JSON file.
  };
}
