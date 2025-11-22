{
  lib,
  config,
  pkgs,
  outputs,
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
    ./security.nix
    ./home-manager.nix
    ./bootloader.nix
    ./users.nix
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
    # Fix for qt6 plugins
    environment.profileRelativeSessionVariables = {
      QT_PLUGIN_PATH = [ "/lib/qt-6/plugins" ];
    };
    system.stateVersion = config.base."nixos-release";

  };
}
