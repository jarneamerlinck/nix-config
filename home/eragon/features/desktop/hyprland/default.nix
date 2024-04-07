{ lib, config, pkgs, inputs,  ... }: {
  imports = [
    ../common
  ];
  modules = [
    inputs.hyprland.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    hyprland
    wayland
  ];
}
