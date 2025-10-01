{
  pkgs,
  lib,
  config,
  ...
}:
{
  services = {
    xserver.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      settings.General.DisplayServer = "x11-user";
      theme = "sddm-tokyo-night";
    };
  };
  environment.systemPackages = with pkgs; [
    sddm-themes.sddm-tokyo-night
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5ct
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols
  ];
}
