{
  pkgs,
  ...
}:
{
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  security.polkit.enable = true;
  hardware.graphics.enable = true; # Only enable inside VM
  programs.xwayland.enable = true;

  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-gtk
  ];

  programs.dconf.enable = true;
  programs.light = {
    enable = true;
    brightnessKeys.enable = true;
  };
  security.pam.services.swaylock = { };
}
