{ inputs, lib, pkgs, config, outputs, ... }:
let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  s_modifier = "Mod4";
  s_terminal = "kitty";
  # s_terminal = "${pkgs.coreutils}/bin/kitty";
in
{
  imports = [ ../common ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = s_modifier; # Super key
      terminal = s_terminal;
      output = {
        "Virtual-1" = {
          mode = "${toString monitor.width}x${toString monitor.height}@60Hz";
        };
      };
    };
    extraConfig = ''
      bindsym ${s_modifier}+t exec ${s_terminal}
    '';
  };
}
