{ config, lib, pkgs, ... }:
let
  rmHash = lib.removePrefix "#";
  inherit (config.colorscheme) palette;
in {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    userSettings = {
      "workbench.colorCustomizations" = {
        "editor.background" = "#${palette.base00}";
        "editor.foreground" = "#${palette.base01}";
        "activityBar.background" = "#${palette.base00}";
        "sideBar.background" = "#${palette.base01}";
        "statusBar.background" = "#${palette.base01}";


        # Menu bar dropdown items
        "menu.background" = "#${palette.base02}";
        "menu.foreground" = "#${palette.base01}";
        "menu.selectionBackground" = "#${palette.base03}";
        "menu.selectionForeground" = "#${palette.base01}";
      };
    };
  };
}
