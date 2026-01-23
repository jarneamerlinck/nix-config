{
  inputs,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  nixvim-package = inputs.nixvim-config.packages.${system}.default;
  extended-nixvim = nixvim-package.extend config.stylix.targets.nixvim.exportedModule;
in
{
  environment.systemPackages = [ extended-nixvim ];
}
