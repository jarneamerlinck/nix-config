{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

}
