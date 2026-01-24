{
  lib,
  config,
  ...
}:
# let
#   monitor = lib.head (lib.filter (m: m.primary) config.monitors);
#   i_modifier = "Mod4";
# in
{
  imports = [
    ../../common
    ../../common/wayland-common.nix
  ];

  home.shellAliases = {
    fsway = "fzf-sway-move-window";
  };
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      output = lib.listToAttrs (
        map (m: {
          name = m.name; # <- key in the attribute set
          value = {
            mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz";
            pos = "${toString m.x} ${toString m.y}";
          };
        }) config.monitors
      );

    };
  };
}
