{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../base
    ../kodi.nix
  ];
  monitors = [
    {
      name = "eDP-1";
      width = 1600;
      height = 900;
      workspace = "1";
      primary = true;
    }
  ];

}
