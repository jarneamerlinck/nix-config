{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.mutableUsers = true; # Only enable if you set password from sops or from nix-config
  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  # Fix for qt6 plugins
  environment.profileRelativeSessionVariables = {
    QT_PLUGIN_PATH = [ "/lib/qt-6/plugins" ];
  };

  users.groups.mounts = {
    name = "mounts";
    gid = 1442; # Group ID, you can choose a suitable ID
  };

}
