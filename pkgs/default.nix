# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs ? import <nixpkgs> { } }: rec {
  sddm-themes = pkgs.callPackage ./sddm-themes.nix { };
  hyprslurp = pkgs.callPackage ./hyprslurp { };
}
