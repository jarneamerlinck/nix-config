{ pkgs, lib, config, ... }:
{
  services = {
    xserver.displayManager.gdm = {
      enable = true;
    };
  };
}
