{ config, lib, pkgs, ... }:

let
  grubEnabled = config.boot.loader.grub.enable;
  grubTheme = "distro-grub-themes";
  fullTheme = pkgs.grub-themes.${grubTheme};
in {
  environment.systemPackages = with pkgs; [ grub-themes.${grubTheme} grub2 ];
  boot.loader.grub = {
    useOSProber = lib.mkDefault false;
    extraConfig = lib.mkIf grubEnabled ''
      set theme=${fullTheme}/share/grub/themes/${grubTheme}/theme.txt
      GRUB_RECORDFAIL_TIMEOUT=0
    '';
    # splashImage = null;
  };
}
