{
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtdeclarative
    libsForQt5.qt5.qtgraphicaleffects
    kdePackages.qt5compat
  ];

  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };
}
