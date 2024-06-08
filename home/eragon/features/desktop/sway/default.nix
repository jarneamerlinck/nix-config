{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [ ../common ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # Super key
      output = {
        "Virtual-1" = {
          mode = "1920x1080@60Hz";
        };
      };
    };
  };
}
