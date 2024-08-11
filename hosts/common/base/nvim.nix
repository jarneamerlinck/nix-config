{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [ inputs.nvim.packages.x86_64-linux.default ];
}
