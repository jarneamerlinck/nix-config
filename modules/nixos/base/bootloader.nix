{
  lib,
  config,
  pkgs,
  inputs,
  outputs,
  ...
}:
{

  options = {

    base."home-manager" = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the home manager module";
          };
        };
      };

      default = { };
    };
  };
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  config = lib.mkIf config.base."home-manager".enable {

    users.mutableUsers = true; # Only enable if you set password from sops or from nix-config
    home-manager.extraSpecialArgs = { inherit inputs outputs; };

  };
}
