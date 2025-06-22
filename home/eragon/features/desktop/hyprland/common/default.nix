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
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "${toString monitor.name}, ${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}, auto, auto"
      ];
    };
    extraConfig = ''
      workspace = w[tv1], gapsout:0, gapsin:0
      workspace = f[1], gapsout:0, gapsin:0
      windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
      windowrule = rounding 0, floating:0, onworkspace:w[tv1]
      windowrule = bordersize 0, floating:0, onworkspace:f[1]
      windowrule = rounding 0, floating:0, onworkspace:f[1]
      bind = SUPER, B, exec, firefox
    '';
  };
}
