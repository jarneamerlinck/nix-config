{ pkgs, lib, config, ... }:
{
  services = {
    xserver = {
      desktopManager.hyprland = {
        enable = true;
      };
    };
  };
  # Fix broken stuff
  services.avahi.enable = false;
  networking.networkmanager.enable = false;
}
