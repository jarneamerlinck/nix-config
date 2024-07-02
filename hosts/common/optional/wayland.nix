{ pkgs, lib, config, ... }:
{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  sound.enable = true;
  security.polkit.enable = true;
  hardware.opengl.enable = true; # Only enable inside VM
  # programs.sway.enable = false;
  # nixpkgs.config.pulseaudio = true;
  # hardware.pulseaudio.enable = true;
}
