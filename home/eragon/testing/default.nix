{
  pkgs,
  ...
}:
{
  imports = [
    ../base
    ../features/desktop/sway/minimalistic
  ];
  wallpaper = pkgs.wallpapers.abstract-cubes;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";

  monitors = [
    {
      name = "eDP-1";
      width = 1600;
      height = 900;
      workspace = "1";
      primary = true;
    }
  ];

}
