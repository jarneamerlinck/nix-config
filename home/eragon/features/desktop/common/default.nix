{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    ./discord.nix
    ./dragon.nix
    ./firefox.nix
    ./mediaPlayer.nix
    ./font.nix
    ./xdg.nix
    ./qt.nix
    ./audio.nix
  ];
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
