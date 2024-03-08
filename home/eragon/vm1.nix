{ lib, pkgs,  ... }:
{
  imports = [
    ./common
    ./features/desktop/gnome
    ./features/services/virtualization
  ];
  # monitors = [{
  #   name = "eDP-1";
  #   width = 1920;
  #   height = 1080;
  #   workspace = "1";
  #   primary = true;
  # }];
}
