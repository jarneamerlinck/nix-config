{
  home = {
    username = lib.mkDefault "eragon";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "25.05";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      FLAKE = "$HOME/nix-config";
      NH_FLAKE = "$HOME/nix-config";
    };
  };
}
