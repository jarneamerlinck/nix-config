{
  lib,
  config,
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  grubEnabled = config.boot.loader.grub.enable;
  grubTheme = "distro-grub-themes";
  fullTheme = pkgs.grub-themes.${grubTheme};
in
{

  options = {
    base.bootloader = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable the theme bootloader module";
          };
        };
      };

      default = { };
    };
  };
  config = lib.mkIf config.base.bootloader.enable {

    environment.systemPackages = with pkgs; [
      grub-themes.${grubTheme}
      grub2
    ];
    boot.loader.grub = {
      useOSProber = lib.mkDefault false;
      extraConfig = lib.mkIf grubEnabled ''
        set theme=${fullTheme}/share/grub/themes/${grubTheme}/theme.txt
        GRUB_RECORDFAIL_TIMEOUT=0
      '';
      # splashImage = null;
    };
  };
}
