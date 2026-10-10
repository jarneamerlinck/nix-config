{ pkgs, config, ... }:
let
  # TODO: Rename user to guest
  session =
    if config.wayland.windowManager.hyprland.enable then
      "Hyprland"
    else if config.wayland.windowManager.sway.enable then
      "sway"
    else
      "startplasma-wayland";
in
{
  home = {
    packages = with pkgs; [
      (pkgs.writeShellScriptBin "greetd-session" ''
        exec "$SHELL" -l -c 'exec ${session}'
      '')
    ];
  };
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        "xkb"
        "be"
      ];
    };
  };

}
