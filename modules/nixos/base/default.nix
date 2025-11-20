{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    base = {
      enable = lib.mkEnableOption "enables base module";
      zsh.enable = lib.mkDefault true;
      sops.enable = lib.mkDefault true;
      openssh.enable = lib.mkDefault true;
      neovim.enable = lib.mkDefault true;
      nix.enable = lib.mkDefault true;
      security.enable = lib.mkDefault true;
    };
  };

  config = lib.mkIf config.base.enable {

    environment.systemPackages = with pkgs; [
      lf
    ];

  };
}
