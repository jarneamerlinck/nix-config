{
  lib,
  config,
  pkgs,
  outputs,
  ...
}:
{
  imports = [
    ./laptop.nix
  ];
  options = {

    hardware = lib.mkOption {
      type = lib.types.submodule {
        options = {
          laptop = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "enables custom laptop module";
                };
              };
            };
          };
          # Desktop, server, ...

        };
      };
    };
  };
  config = lib.mkMerge [

    (lib.mkIf config.hardware.laptop.enable {
      hardware.bluetooth.enable = lib.mkForce true;
      hardware.hibernation.enable = lib.mkForce true;
      hardware.battery.enable = lib.mkForce true;

    })

  ];
}
