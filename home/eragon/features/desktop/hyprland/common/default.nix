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
  home.sessionVariables = {
    TERMINAL = "kitty";
  };


  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        "${toString monitor.name}, ${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}, auto, auto"
      ];
      input =  {
        kb_layout = "be";
      };
    };
    extraConfig = ''
    '';
  };
}
