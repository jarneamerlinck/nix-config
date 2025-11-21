{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-packages.nix
    ./nvim.nix
    ./openssh.nix
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
