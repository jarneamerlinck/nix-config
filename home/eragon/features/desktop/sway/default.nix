{ inputs, lib, pkgs, config, outputs, ... }:
let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  i_modifier = "Mod4";
  i_terminal = "kitty";
  i_keyboard = "be";
in
{
  imports = [ ../common ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = i_modifier; # Super key
      terminal = i_terminal;
      output = {
        "Virtual-1" = {
          mode = "${toString monitor.width}x${toString monitor.height}@60Hz";
        };
      };
    };
    extraConfig = ''
      bindsym ${i_modifier}+t exec ${i_terminal}


      input "type:keyboard" {
        xkb_layout ${i_keyboard}
      }
    '';
  };
}
