{ pkgs, ... }:

{
  imports = [
    ./compatibility.nix
    ./steam.nix
  ];
}
