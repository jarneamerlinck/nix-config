{ lib, pkgs, inputs,  ... }:
{
  imports = [
    ./common
    ./features/cli/debugging.nix
    ./features/cyber
  ];
  # wallpaper = pkgs.wallpapers.nixos-logo;

  colorScheme = inputs.nix-colors.colorSchemes.brewer;
}
