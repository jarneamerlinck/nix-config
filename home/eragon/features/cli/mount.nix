{ outputs, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    cifs-utils
  ];

}
