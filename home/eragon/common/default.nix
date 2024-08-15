{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
let
  inherit (inputs.nix-colors) colorSchemes;
  # inherit (nix-colors.lib-contrib { inherit pkgs; }) nixWallpaperFromScheme;
in
{
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModules.default
    ../features/cli
  ] ++ (builtins.attrValues outputs.homeManagerModules);
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
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
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
    stateVersion = lib.mkDefault "23.05";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = {
      # FLAKE = "$HOME/Documents/NixConfig";
      FLAKE = "$HOME/nix-config";
    };
  };

  # Set default wallpaper and colorscheme
  # Available color schemes can be found at https://tinted-theming.github.io/base16-gallery/
  colorScheme = lib.mkDefault inputs.nix-colors.colorSchemes.atelier-heath;
  wallpaper = lib.mkDefault pkgs.wallpapers.nixos-logo;

  # specialisation = {
  #     dark.configuration.colorscheme.mode = lib.mkOverride 1498 "dark";
  #    light.configuration.colorscheme.mode = lib.mkOverride 1498 "light";
  # };
  home.file = {
    ".colorscheme.json".text = builtins.toJSON config.colorscheme;
  };
  # home.packages = let
  #   specialisation = pkgs.writeShellScriptBin "specialisation" ''
  #     profiles="$HOME/.local/state/nix/profiles"
  #     current="$profiles/home-manager"
  #     base="$profiles/home-manager-base"
  #
  #     # If current contains specialisations, link it as base
  #     if [ -d "$current/specialisation" ]; then
  #       echo >&2 "Using current profile as base"
  #       ln -sfT "$(readlink "$current")" "$base"
  #     # Check that $base contains specialisations before proceeding
  #     elif [ -d "$base/specialisation" ]; then
  #       echo >&2 "Using previously linked base profile"
  #     else
  #       echo >&2 "No suitable base config found. Try 'home-manager switch' again."
  #       exit 1
  #     fi
  #
  #     if [ "$1" = "list" ] || [ "$1" = "-l" ] || [ "$1" = "--list" ]; then
  #       find "$base/specialisation" -type l -printf "%f\n"
  #       exit 0
  #     fi
  #
  #     echo >&2 "Switching to ''${1:-base} specialisation"
  #     if [ -n "$1" ]; then
  #       "$base/specialisation/$1/activate"
  #     else
  #       "$base/activate"
  #     fi
  #   '';
  #   toggle-theme = pkgs.writeShellScriptBin "toggle-theme" ''
  #     if [ -n "$1" ]; then
  #       theme="$1"
  #     else
  #       current="$(${lib.getExe pkgs.jq} -re '.kind' "$HOME/.colorscheme.json")"
  #       if [ "$current" = "light" ]; then
  #         theme="dark"
  #       else
  #         theme="light"
  #       fi
  #     fi
  #     ${lib.getExe specialisation} "$theme"
  #   '';
  # in [ specialisation toggle-theme ];
}
