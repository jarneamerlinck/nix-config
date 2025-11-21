{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    base."hardware-packages" = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enables hardware packages module";
      };
    };
  };

  config = lib.mkIf config.base."hardware-packages".enable {

    environment.systemPackages = with pkgs; [
      pciutils
      openssl
    ];

  };
}
