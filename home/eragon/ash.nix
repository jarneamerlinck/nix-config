{ lib, pkgs, ... }:
{
  imports = [
    ./common
    ./features/cli/mount.nix
  ];
}
