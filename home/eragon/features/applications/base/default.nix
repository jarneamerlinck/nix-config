{ lib, ... }:
{
  imports = [
    ./firefox.nix
    ./scanner.nix
  ];
  dconf.settings."org/gnome/desktop/interface".color-scheme = lib.mkDefault "prefer-dark";
}
