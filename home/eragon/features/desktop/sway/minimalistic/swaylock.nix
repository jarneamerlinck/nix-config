{
  config,
  pkgs,
  ...
}:
let
  
  inherit (config.colorscheme) palette;
in
{
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

      # Own settings
      color = "${palette.base00}";
      inside-color = "${palette.base00}";
      font = "${config.fontProfiles.monospace.family}";
      text-color = "${palette.base05}";
      text-caps-lock-color = "${palette.base07}";
      line-color = "${palette.base01}";

      ring-color = "${palette.base06}";
      key-h1-color = "${palette.base0A}";


      ring-clear-color = "${palette.base00}";

      ring-wrong-color = "${palette.base09}";
      inside-wrong-color = "${palette.base09}";

    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${config.programs.swaylock.package}/bin/swaylock -f -c 000000";
      }
    ];
    timeouts = [
      { timeout = 60*5;  command = "${config.programs.swaylock.package}/bin/swaylock"; }
      { timeout = 90*10; command = "${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };
}
