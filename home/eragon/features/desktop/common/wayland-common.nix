{ pkgs, config, ... }:
let
  session =
    if config.wayland.windowManager.hyprland.enable then
      "Hyprland"
    else if config.wayland.windowManager.sway.enable then
      "sway"
    else
      "sway";
in
{
  home = {
    packages = with pkgs; [
      wl-clipboard
      (pkgs.writeShellScriptBin "greetd-session" ''
        exec "$SHELL" -l -c 'exec ${session}'
      '')
    ];
  };
}
