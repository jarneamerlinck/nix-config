{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    base."hardware-packages" = {
      enable = lib.mkEnableOption "enables hardware packages module";
    };
  };

  config = lib.mkIf config.base."hardware-packages".enable {

    environment.systemPackages = with pkgs; [
      pciutils
      openssl
    ];

  };
}
