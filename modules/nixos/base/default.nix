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
  ];
  options = {

    base = {
      enable = lib.mkEnableOption "enables base module";
    };
  };

  # config = lib.mkIf config.base.enable {
  #
  # };
}
