{ outputs, lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    libnotify
  ];

}
