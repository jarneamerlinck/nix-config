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
  ];
  options = {

    base = {
      enable = lib.mkEnableOption "enables base module";
      zsh.enable = lib.mkDefault true;
      sops.enable = lib.mkDefault true;
      openssh.enable = lib.mkDefault true;
      nix.enable = lib.mkDefault true;
      security.enable = lib.mkDefault true;
    };
  };

  config = lib.mkIf config.base.enable {

  };
}
