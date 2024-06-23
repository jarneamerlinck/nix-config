{ config, lib, pkgs, ... }:

let
  grubEnabled = config.boot.loader.grub.enable;
  grubTheme = "distro-grub-themes";
  fullTheme = pkgs.grub-themes.${grubTheme};
in
{
  environment.systemPackages = with pkgs;[
   grub-themes.${grubTheme}
   grub2
  ];
  boot.loader.grub = {
    extraConfig = lib.mkIf grubEnabled "set theme=${fullTheme}/share/grub/themes/${grubTheme}/theme.txt";
    # splashImage = null;
  };
}
