{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  i_modifier = "Mod4";
in
{
  imports = [
    ../../common
    ../../common/wayland-common.nix
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      output = {
        "Virtual-1" = {
          mode = "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}Hz";
        };
      };
    };
  };
}
