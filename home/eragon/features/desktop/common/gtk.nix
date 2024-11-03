{
  config,
  pkgs,
  ...
}:
let
  inherit (config.colorscheme) palette;
in {

  gtk = {
    enable = true;

    # Set the GTK theme colors based on nix-colors
    # theme = {
    #   name = "${config.colorScheme.slug}";
    #   package = gtkThemeFromScheme { scheme = config.colorScheme; };
    # };
  };

}
