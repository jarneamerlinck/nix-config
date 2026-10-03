{ config, pkgs, ... }:
{
  # security.pam.services.swaylock = {
  #   fprintAuth = true;
  #   # Ensures swaylock doesn't block waiting for password if fingerprint is scanned first
  #   text = ''
  #     auth sufficient pam_unix.so try_first_pass likeauth nullok
  #     auth sufficient pam_fprintd.so
  #     auth include login
  #   '';
  # };
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      show-failed-attempts = true;
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;
      line-uses-ring = false;
      grace = 0;
      grace-no-mouse = true;
      grace-no-touch = true;
      datestr = "%d.%m";
      fade-in = "0.1";
      ignore-empty-password = true;

    };
  };

  services.swayidle = {
    enable = true;
    events = {
      "before-sleep" = "${config.programs.swaylock.package}/bin/swaylock";
    };
    timeouts = [
      {
        timeout = 60 * 10;
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
    ];
  };
  stylix.targets.swaylock = {
    enable = true;
    image.enable = true;
  };
}
