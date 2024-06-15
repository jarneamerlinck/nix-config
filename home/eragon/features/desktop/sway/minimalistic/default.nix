{ inputs, lib, pkgs, config, outputs, ... }:
let
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
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = i_modifier; # Super key
      terminal = i_terminal;
    };
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
