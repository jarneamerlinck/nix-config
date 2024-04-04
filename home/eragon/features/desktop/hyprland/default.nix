{ lib, config, pkgs, inputs,  ... }: {
  imports = [
    ../common
    inputs.hyprland.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    hyprland
    wayland
  ];


  wayland.windowManager.hyprland.enable = true;
}
