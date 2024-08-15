# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs ? import <nixpkgs> { } }: rec {
  sddm-themes = pkgs.callPackage ./sddm-themes.nix { };
  grub-themes = pkgs.callPackage ./grub-themes.nix { };
  hyprslurp = pkgs.callPackage ./hyprslurp { };

  # Wallpapers
  wallpapers = import ./wallpapers {inherit pkgs;};
  allWallpapers = pkgs.linkFarmFromDrvs "wallpapers" (pkgs.lib.attrValues wallpapers);

  # Color
  generateColorscheme = import ./colorschemes/generator.nix {inherit pkgs;};
  colorschemes = import ./colorschemes {inherit pkgs wallpapers generateColorscheme;};
  allColorschemes = let
    # This is here to help us keep IFD cached (hopefully)
    combined = pkgs.writeText "colorschemes.json" (builtins.toJSON (pkgs.lib.mapAttrs (_: drv: drv.imported) colorschemes));
  in
    pkgs.linkFarmFromDrvs "colorschemes" (pkgs.lib.attrValues colorschemes ++ [combined]);
}
