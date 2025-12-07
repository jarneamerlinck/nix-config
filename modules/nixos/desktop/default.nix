{
  lib,
  config,
  pkgs,
  outputs,
  ...
}:
{
  imports = [
    # ./login_manager.nix

  ];
  options = {

    desktop = lib.mkOption {
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
  config = lib.mkIf config.desktop.enable {

    # desktop.loginManager.enable = lib.mkForce true;

  };
}
