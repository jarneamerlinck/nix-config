{ inputs, lib, pkgs, config, outputs, ... }:
let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
in
{
  imports = [ ../common ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # Super key
      output = {
        "Virtual-1" = {
          mode = "${toString monitor.width}x${toString monitor.height}@60Hz";
        };
      };
    };
  };
}
