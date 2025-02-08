{ config, pkgs, ... }:

{
  imports = [
    ./qemu.nix
    ./docker.nix
    ./wine.nix

  ];
}
