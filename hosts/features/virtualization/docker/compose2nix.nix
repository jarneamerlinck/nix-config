{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  environment.systemPackages = [ inputs.compose2nix ];
}
