{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    base."package-list" = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "creates a file under /etc/current-system-packages with a list of all the systempackages";
      };
    };
  };

  config = lib.mkIf config.base."package-list".enable {

    environment.etc."current-system-packages".text =
      let
        packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
        sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
        formatted = builtins.concatStringsSep "\n" sortedUnique;
      in
      formatted;
  };
}
