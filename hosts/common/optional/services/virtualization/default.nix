{ config, pkgs, ... }:

{
  imports = [
    ./qemu.nix
    ./docker.nix

  ];

  environment.systemPackages = with pkgs; [
    flatpak
  ];

}
