# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{ pkgs ? import <nixpkgs> { } }: rec {
  sddm-themes = pkgs.callPackage ./sddm-themes.nix { };
  tokyo-night-sddm = pkgs.callPackage ./tokyo-night-sddm.nix { };
}
