{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{

  options = {

    base.nix = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the mount points module";
          };

          gc = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable garbage collection";
          };
          "system-features" = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "kvm"
              "big-parallel"
              "nixos-test"
            ];
            description = "Select system-features";
          };

          substituters = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
            ];
            description = "Set nix cache substituters";
          };

          "trusted-public-keys" = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
            ];
            description = "Set nix cache thrusted keys";
          };
        };
      };

      default = { };
    };
  };

  config = lib.mkIf config.base.nix.enable {

    environment.systemPackages = with pkgs; [ nh ];
    nix = {

      settings = {
        substituters = config.base.nix.substituters;
        trusted-public-keys = config.base.nix."trusted-public-keys";
        trusted-users = [
          "root"
          "@wheel"
        ];
        auto-optimise-store = lib.mkDefault true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
        system-features = config.base.nix."system-features";
        flake-registry = ""; # Disable global flake registry
      };
      gc = lib.mkIf config.base.nix.gc {
        # garbage collection
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 14d";
      };

      # Add each flake input as a registry
      # To make nix3 commands consistent with the flake
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

      # Add nixpkgs input to NIX_PATH
      nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
    };
  };
}
