{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../base
    ../features/applications/base
    ../features/desktop/sway/minimalistic
  ];
  wallpaper = pkgs.wallpapers.nixos-logo;

  colorScheme = inputs.nix-colors.colorSchemes.bright;

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
