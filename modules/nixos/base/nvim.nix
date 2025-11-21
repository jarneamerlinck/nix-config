{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{

  options = {

    base.neovim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable neovim in the base module";
      };
    };
  };

  config = lib.mkIf config.base.neovim.enable {

    environment.systemPackages = with pkgs; [
      inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  };
}
