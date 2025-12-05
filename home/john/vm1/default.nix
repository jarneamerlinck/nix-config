{
  lib,
  pkgs,
  inputs,
  config,
  outputs,
  ...
}:
{

  imports = [
    inputs.nur.modules.homeManager.default
    inputs.sops-nix.homeManagerModule
  ]
  ++ (builtins.attrValues outputs.homeManagerModules);

  systemd.user.startServices = "sd-switch";

  home = {
    username = lib.mkDefault "john";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "25.05";
    sessionPath = [ "$HOME/.local/bin" ];
  };
  programs.bash.enable = true;
}
