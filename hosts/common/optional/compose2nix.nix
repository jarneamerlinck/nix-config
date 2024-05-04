{ pkgs, lib, config, inputs, ... }:
{
  environment.systemPackages =  [
    compose2nix.packages.x86_64-linux.default
  ];
}
