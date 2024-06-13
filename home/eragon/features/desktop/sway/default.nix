{ inputs, lib, pkgs, config, outputs, ... }:
let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  i_modifier = "Mod4";
  i_terminal = "kitty";
  i_keyboard = "be";
in
{
  imports = [
    ../common
    ./shotman.nix
    ./waybar.nix
    ./notifications.nix
    ./wayland-common.nix
  ];
  wayland.windowManager.sway = {
    enable = true;
    enableBar = false;
    config = rec {
      modifier = i_modifier; # Super key
      terminal = i_terminal;
      output = {
        "Virtual-1" = {
          mode = "${toString monitor.width}x${toString monitor.height}@60Hz";
        };
      };
    };
    # extraSessionCommands = ''
    #   set $menu wofi
    # '';
    extraConfig = ''
      bindsym ${i_modifier}+t exec ${i_terminal}
      bindsym ${i_modifier} exec ${pkgs.wofi}/bin/wofi
      bindsym ${i_modifier}+q kill

      bindsym Print exec shotman -c output
      input "type:keyboard" {
        xkb_layout ${i_keyboard}
      }
    '';
  };
}
