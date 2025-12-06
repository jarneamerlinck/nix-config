{
  lib,
  config,
  pkgs,
  outputs,
  ...
}:
{
  imports = [
    ./login_manager.nix
  ];
  options = {

    desktop = lib.mkOption {
      type = lib.types.submodule {
        options = {
          laptop = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "enables desktop module";
                };
              };
            };
          };

        };
      };
    };
  };
  config = lib.mkMerge [

    (lib.mkIf config.desktop.enable {
      desktop."login-manager".enable = lib.mkForce true;
      hardware.battery.enable = lib.mkForce true;

    })

  ];
}
