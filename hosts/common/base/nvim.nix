{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages =  [
    inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

}
