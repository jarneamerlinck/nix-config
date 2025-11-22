{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in

{

  options = {

    base.sops = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the sops module";
          };
        };
      };

      default = { };
    };
  };

  imports = [ inputs.sops-nix.nixosModules.sops ];
  config = lib.mkIf config.base.sops.enable {

    environment.systemPackages = with pkgs; [
      sops
      age
    ];

    sops = {
      age.sshKeyPaths = map getKeyPath keys;
    };
  };
}
