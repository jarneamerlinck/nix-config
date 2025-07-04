{ lib, config, ... }:

let
  mkFontOption = variant: {
    family = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Family name for ${variant} font profile";
      example = "Fira Code";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${variant} font profile";
      example = "pkgs.nerd-fonts.fira-code";
    };
  };
  cfg = config.fontProfiles;
in
{
  options.fontProfiles = {
    enable = lib.mkEnableOption "Whether to enable font profiles";
    monospace = mkFontOption "monospace";
    regular = mkFontOption "regular";
  };


  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [ cfg.monospace.package cfg.regular.package ];
  };
}
