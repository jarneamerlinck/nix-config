{ inputs, lib, pkgs, config, outputs, ... }:
let
  monitor = lib.head (lib.filter (m: m.primary) config.monitors);
  i_modifier = "Mod4";
in {
  imports = [ ../../common ../../common/wayland-common.nix ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      output = lib.listToAttrs (map (m: {
        name = m.name; # <- key in the attribute set
        value = {
          # mode string – add @refreshRate only if it exists
          mode = "${toString m.width}x${toString m.height}"
            + (if m ? refreshRate then "@${toString m.refreshRate}Hz" else "");
          # you can add other properties per‑monitor here (scale, transform, etc.)
        };
      }) config.monitors);

    };
  };
}
