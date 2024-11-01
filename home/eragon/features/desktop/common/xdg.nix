{ pkgs, config, ... }: let
    inherit (config.colorscheme) palette harmonized;
in {

  home = {
    packages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };
}
