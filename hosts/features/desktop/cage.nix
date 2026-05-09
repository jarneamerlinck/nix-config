{
  pkgs,
  lib,
  ...
}:
{

  # TODO: add systemctl to restore back to default
  # TODO: after boot default should always be default and not tablet
  # TODO: allow ctrl+alt+f4 to work
  # Test on baruuk

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.cage = {
    enable = true;
    user = "eragon";
    program = "${pkgs.firefox}/bin/firefox --no-remote  --kiosk http://127.0.0.1:38080";
  };
  systemd.services."cage-tty1".after = [
    "network-online.target"
    "systemd-resolved.service"
    "docker-excalidraw-excalidraw.service"
  ];
  services.greetd.enable = lib.mkForce false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # security.polkit.enable = true;
  # hardware.graphics.enable = true; # Only enable inside VM
  # programs.xwayland.enable = true;

  programs.dconf.enable = true;
  programs.light = {
    enable = true;
    brightnessKeys.enable = true;
  };
  # security.pam.services.swaylock = { };
}
