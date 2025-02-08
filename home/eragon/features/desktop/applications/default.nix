{
  ...
}:
{
  imports = [
    ./firefox.nix
  ];
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
