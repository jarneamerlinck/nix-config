{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
{

  home = {
    username = lib.mkDefault "john";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "25.05";
    sessionPath = [ "$HOME/.local/bin" ];
  };
  programs.bash.enable = true;
}
