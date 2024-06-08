{ pkgs, lib, config, ... }:
{
  programs.sway = {
    enable = true;
  };
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  sound.enable = true;
  # nixpkgs.config.pulseaudio = true;
  # hardware.pulseaudio.enable = true;
}
