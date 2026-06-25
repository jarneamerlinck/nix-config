{
  pkgs,
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
    qt5.qtsvg
    qt5ct
    qt5.qtgraphicaleffects
    qt5.qtquickcontrols
  ];
}
