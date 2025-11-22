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
      nixPath = [
        "nixpkgs=${inputs.nixpkgs.outPath}"
        "/etc/nix/path" # Needed for legacy
      ];

    };
    nixpkgs = {
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        # outputs.overlays.unstable-packages

        # You can also add overlays exported from other flakes:
        # neovim-nightly-overlay.overlays.default

        # Or define it inline, for example:
        # (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
        # })
      ];
      config = {
        allowUnfree = true;
      };
    };

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    environment.etc = lib.mapAttrs' (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    }) config.nix.registry;
  };
}
