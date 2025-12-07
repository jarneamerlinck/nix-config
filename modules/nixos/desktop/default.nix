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
    ./compositor.nix
  ];
  options = {

    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enables desktop module";
      };

      compositor = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Enable compositor module module";
            };

            compositorType = lib.mkOption {
              type = lib.types.enum [
                "x11"
                "wayland"
              ];
              default = "wayland";
              description = "Compositor to use";
            };
          };
        };
      };
    };
  };
  config = lib.mkIf config.desktop.enable {

    desktop.loginManager.enable = lib.mkForce true;
    desktop.compositor.enable = lib.mkForce true;

  };
}
