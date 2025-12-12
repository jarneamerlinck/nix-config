{ pkgs, config, ... }:
let
  i_keyboard = "be";
  cfg = config.wayland.windowManager.hyprland.config;

in
{
  imports = [ ../common ];

  home.packages = with pkgs; [
    procps
    jq
    playerctl
  ];

}
