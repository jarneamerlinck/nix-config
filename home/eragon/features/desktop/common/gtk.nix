{
  config,
  pkgs,
  ...
}:
let
  themeName = "nix-color";
  colorPalette = ''
    /* GTK Theme generated from nix-colors */

  '';
in
{
  home.file.".themes/${themeName}/gtk-2.0/gtk.css".text = colorPalette;
  home.file.".themes/${themeName}/gtk-3.0/gtk.css".text = colorPalette;
  home.file.".themes/${themeName}/gtk-4.0/gtk.css".text = colorPalette;

  gtk = {
    enable = true;
    theme = {
      name = "${themeName}";
    };
  };

  services.xsettingsd = {
    enable = true;
    settings = {
      "Net/ThemeName" = "${themeName}";
      "Net/IconThemeName" = "${config.fontProfiles.regular.family}";
    };
  };

}
