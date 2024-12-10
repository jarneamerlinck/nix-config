{ pkgs, lib, config, ... }:
{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;
  hardware.graphics.enable = true; # Only enable inside VM
  # programs.sway.enable = false;
  # nixpkgs.config.pulseaudio = true;
  # hardware.pulseaudio.enable = true;
}
