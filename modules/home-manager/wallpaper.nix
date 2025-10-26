{ lib, ... }:
let inherit (lib) types mkOption;
in {
  options.wallpaper = mkOption {
    type = types.nullOr types.path;
    default = null;
    description = ''
      Wallpaper path
    '';
  };

  options.wallpaper-list = mkOption {
    type = types.listOf types.path;
    default = [ ];
    description = ''
      List of wallpaper paths
    '';
  };
}
