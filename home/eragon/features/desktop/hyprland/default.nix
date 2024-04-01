{ lib, config, pkgs, inputs,  ... }: {
  imports = [
    ../common
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # package = pkgs.inputs.hyprland.hyprland.override { wrapRuntimeDeps = false; };
  };
}
