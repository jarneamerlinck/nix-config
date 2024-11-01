{ pkgs, ... }: {

  home = {
    packages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };
  xdg = {
    gtk = {
      enable = true;
      theme = "Adwaita-dark";  # Or another dark GTK theme you prefer
    };
    iconTheme = "Papirus-Dark";  # Optional, for a matching dark icon theme
  };
}
