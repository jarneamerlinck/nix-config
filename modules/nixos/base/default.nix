{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-defaults.nix
    ./nix.nix
    ./nvim.nix
    ./openssh.nix
    ./zsh.nix
    ./package-list.nix
    ./mounts.nix
    ./networking.nix
    ./sops.nix
  ];
  options = {

    base = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "enables base module";
      };

      "nixos-release" = lib.mkOption {
        type = lib.types.str;
        default = "25.05";
        description = "Set Nixos release version";
      };

    };
  };

  config = lib.mkIf config.base.enable {

    system.stateVersion = config.base."nixos-release";
  };
}
