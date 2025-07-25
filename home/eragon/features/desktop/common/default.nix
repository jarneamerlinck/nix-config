{
  config,
  lib,
  ...
}:
{
  imports = [
    ./dragon.nix
    ./xdg.nix
    ./qt.nix
    ./gtk.nix
    ./audio.nix
  ];

  dconf.settings."org/gnome/desktop/interface".color-scheme = lib.mkDefault "prefer-dark";

  xdg.portal.enable = true;
}
