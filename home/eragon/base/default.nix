{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
{
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nur.modules.homeManager.default
    inputs.sops-nix.homeManagerModule
    ../features/cli
  ]
  ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  home = {
    username = lib.mkDefault "eragon";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "25.11";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      FLAKE = "${config.home.homeDirectory}/nix-config";
      NH_FLAKE = "${config.home.homeDirectory}/nix-config";
    };
  };

  # Set default wallpaper and colorscheme
  # Available color schemes can be found at
  stylix.enable = true;
  stylix.autoEnable = true;

  stylix.image = lib.mkDefault "${pkgs.wallpapers.sci-fi-holographic-abstract}";
  stylix.polarity = lib.mkDefault "dark";

}
