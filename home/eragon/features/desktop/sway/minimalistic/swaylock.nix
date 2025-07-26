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
  config.stylix.targets.swaylock = {
    enable = true;
    useWallpaper = true;
  };
}
