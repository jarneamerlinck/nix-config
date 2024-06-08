{ pkgs, lib, config, ... }:
{
  services.xserver = {
    enable = false;
  };
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
