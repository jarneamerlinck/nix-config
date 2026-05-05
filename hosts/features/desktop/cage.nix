{
  pkgs,
  ...
}:
{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.cage = {
    enable = true;
    user = "eragon";
    program = "${pkgs.firefox}/bin/firefox -kiosk https://music.ko0.net";
  };
  systemd.services."cage-tty1".after = [
    "network-online.target"
    "systemd-resolved.service"
  ];

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
