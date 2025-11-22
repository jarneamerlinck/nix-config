{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    base.zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable zsh module";
      };
    };
  };

  config = lib.mkIf config.base.zsh.enable {

    programs.zsh = {
      enable = true;
    };
  };
}
