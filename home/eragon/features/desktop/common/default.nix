{
  config,
  ...
}:
{
  imports = [
    ./dragon.nix
    ./font.nix
    ./xdg.nix
    ./qt.nix
    ./gtk.nix
    ./audio.nix
  ];

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  xdg.portal.enable = true;
}
