{ pkgs, lib, config, ... }:
{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;
  hardware.opengl.enable = true; # Only enable inside VM
  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-kde
  ];
  # programs.sway.enable = false;
  # nixpkgs.config.pulseaudio = true;
  # hardware.pulseaudio.enable = true;
}
