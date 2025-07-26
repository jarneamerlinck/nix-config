{
  config,
  pkgs,
  ...
}:
let
  palette = config.lib.stylix.colors;
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

      # Stylix colors (adjust depending on swaylock-effects support)
      inside-color = "${palette.base00}ff";
      ring-color = "${palette.base0D}ff";
      text-color = "${palette.base05}ff";
      key-hl-color = "${palette.base0B}ff";
      bs-hl-color = "${palette.base08}ff";
      ring-ver-color = "${palette.base0B}ff";
      ring-wrong-color = "${palette.base08}ff";
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
    ];
    timeouts = [
      {
        timeout = 60 * 5;
        command = "${config.programs.swaylock.package}/bin/swaylock";
      }
    ];
  };
}
