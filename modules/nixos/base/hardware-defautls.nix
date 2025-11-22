{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    base."hardware-defaults" = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enables hardware packages module";
      };
    };
  };

  config = lib.mkIf config.base."hardware-defaults".enable {

    environment.systemPackages = with pkgs; [
      pciutils
      openssl
      mailutils
    ];

    # Set default console keyboard
    console.keyMap = "be-latin1";
    hardware.enableRedistributableFirmware = true;

    # needed for https://github.com/nix-community/disko/issues/451
    boot.swraid.mdadmConf = ''
      MAILADDR eragon@localhost
    '';
  };
}
