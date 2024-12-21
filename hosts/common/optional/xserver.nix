{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;[
    xdg-desktop-portal
  ];
  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
  };
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
