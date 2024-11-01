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
    # ./deluge.nix
    ./discord.nix
    ./dragon.nix
    ./firefox.nix
    ./mediaPlayer.nix
    ./font.nix
    ./xdg.nix
    # ./gtk.nix
    # ./kdeconnect.nix
    # ./pavucontrol.nix

  ];
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
}
