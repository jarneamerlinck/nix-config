{ pkgs, lib, config, ... }:
{
  services = {
    xserver = {
      desktopManager.gnome = {
        enable = true;
      };
    };
    gnome.core-utilities.enable = false;
  };
  # Fix broken stuff
  services.avahi.enable = false;
  networking.networkmanager.enable = false;
  # Remove gnome extra tools
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]);
}
