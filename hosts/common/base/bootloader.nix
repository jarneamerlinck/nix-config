{ config, lib, pkgs, ... }:

let
  grubEnabled = config.boot.loader.grub.enable;
in
{
  environment.systemPackages = [
   pkgs.libsForQt5.breeze-grub
  ];
  boot.loader.grub = {
    extraConfig = lib.mkIf grubEnabled "set theme=${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze/theme.txt";
    splashImage = null;
  };
}
