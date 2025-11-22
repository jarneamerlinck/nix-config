{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-defaults.nix
    ./nvim.nix
    ./openssh.nix
    ./zsh.nix
    ./package-list.nix
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
