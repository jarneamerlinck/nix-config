{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    base.networking = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the networking module";
          };

          hostname = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Set hostname";
          };
          dhcp = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable dhcp";
          };
          nameservers = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "1.1.1.1"
            ];
            description = "Set nameservers for the host";
          };
        };
      };

      default = { };
    };
  };

  config = lib.mkIf config.base.networking.enable {

    networking = {
      hostName = config.base.networking.hostname;
      useDHCP = config.base.networking.dhcp;
      nameservers = config.base.networking.nameservers;
    };
  };
}
