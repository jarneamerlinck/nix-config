{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  wallpapers = import ./wallpapers { inherit pkgs; };
in {
  sddm-themes   = pkgs.callPackage ./sddm-themes.nix { };
  grub-themes   = pkgs.callPackage ./grub-themes.nix { };
  lens          = pkgs.callPackage ./lens.nix { };
  excalidraw    = pkgs.callPackage ./excalidraw-kiosk.nix { };

  wallpapers    = wallpapers;
  allWallpapers = pkgs.linkFarmFromDrvs "wallpapers" (pkgs.lib.attrValues wallpapers);
}
