{ pkgs, config, ... }: let
    inherit (config.colorscheme) palette harmonized;
in {

  home = {
    packages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };
  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name = "${config.colorScheme}";
    gtk-application-prefer-dark-theme = true
  '';
}
