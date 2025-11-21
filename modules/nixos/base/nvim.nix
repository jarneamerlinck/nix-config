{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{

  options = {

    base."neovim" = {
      enable = lib.mkEnableOption "enables nvim module";
    };
  };

  config = lib.mkIf config.base."neovim".enable {

    environment.systemPackages = with pkgs; [
      inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  };
}
