# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs ? import <nixpkgs> { } }: rec {
  sddm-themes = pkgs.callPackage ./sddm-themes.nix { };
  grub-themes = pkgs.callPackage ./grub-themes.nix { };
  hyprslurp = pkgs.callPackage ./hyprslurp { };
  wallpapers = import ./wallpapers {inherit pkgs;};
  allWallpapers = pkgs.linkFarmFromDrvs "wallpapers" (pkgs.lib.attrValues wallpapers);

}
