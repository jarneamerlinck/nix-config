{
  pkgs,
  ...
}:
{

  home.packages = with pkgs; [
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtgraphicaleffects
    kdePackages.qt5compat
  ];

  programs.quickshell = {
    enable = true;
    systemd.enable = false;
  };
}
