
{ outputs, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nerdfonts
    fira-code-nerdfont
  ];

}
