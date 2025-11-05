{
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.stylix.homeModules.stylix
    inputs.nur.modules.homeManager.default
    inputs.sops-nix.homeManagerModule
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

  # systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  # Set default wallpaper and colorscheme
  # Available color schemes can be found at
  stylix.enable = true;
  stylix.autoEnable = true;

  stylix.polarity = lib.mkDefault "dark";

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
  # stylix.image = "${pkgs.wallpapers.star-trails-5k-i0-16-10}";
}
