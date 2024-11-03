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
  inherit (config.colorscheme) palette;
  inherit (inputs.nix-colors.lib-contrib) colorSchemeFromPicture gtkThemeFromScheme;
  # inherit (nix-colors.lib-contrib { inherit pkgs; }) nixWallpaperFromScheme;
  colorScheme = colorSchemeFromPicture {
    path = "https://images.hdqwalls.com/wallpapers/linux-nixos-7q.jpg";
    variant = "dark";
  };

in
{
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModule
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
  # Available color schemes can be found at
  # https://tinted-theming.github.io/base16-gallery/
  colorScheme = lib.mkDefault inputs.nix-colors.colorSchemes.atelier-heath;
  wallpaper = lib.mkDefault pkgs.wallpapers.nixos-logo;

  # specialisation = {
  #     dark.configuration.colorscheme.mode = lib.mkOverride 1498 "dark";
  #    light.configuration.colorscheme.mode = lib.mkOverride 1498 "light";
  # };
  home.file = {
    ".colorscheme.json".text = builtins.toJSON config.colorscheme;
  };

 # look at /home/eragon/repos/cloning/misterio77-nix-config/home/gabriel/features/desktop/common/gtk.nix
  #  gtk = {
  #   enable = true;
  #   theme = {
  #   };
  # };
  gtk = {
    enable = true;

    # Set the GTK theme colors based on nix-colors
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme { scheme = colorScheme; };
    };

    # Apply custom colors from nix-colors to GTK
    # colors = {
    #   gtk.background = "#${palette.base00}";
    #   gtk.foreground = "#${palette.base01}";
    #   gtk.selected_bg_color = "#${palette.base04}";
    #   gtk.selected_fg_color = "#${palette.base05}";
    #   gtk.tooltip_bg_color = "#${palette.base04}";
    #   gtk.tooltip_fg_color = "#${palette.base05}";
    #
    #   # Additional colors if available, adjust based on color scheme details
    #   gtk.text_bg_color = "#${palette.base04}";
    #   gtk.text_fg_color = "#${palette.base06}";
    #   gtk.button_bg_color = "#${palette.base02}";
    #   gtk.button_fg_color = "#${palette.base03}";
    #   gtk.header_bg_color = "#${palette.base02}";
    #   gtk.header_fg_color = "#${palette.base03}";
    # };
  };
  # gtk = {
  #   enable = true;
  #   font = {
  #     name = config.fontProfiles.regular.family;
  #     size = 12;
  #   };
  #   theme = let
  #     inherit (config.colorscheme) mode colors;
  #     name = "generated-${hashString "md5" (toJSON colors)}-${mode}";
  #   in {
  #     inherit name;
  #     package = materiaTheme name (
  #       lib.mapAttrs (_: v: lib.removePrefix "#" v) colors
  #     );
  #   };
    # iconTheme = {
    #   name = "Papirus-${
    #     if config.colorscheme.mode == "dark"
    #     then "Dark"
    #     else "Light"
    #   }";
    #   package = pkgs.papirus-icon-theme;
    # };
  # };
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
