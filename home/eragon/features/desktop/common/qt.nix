{ lib, ... }:
{
  stylix.targets.qt.enable = true;
  stylix.targets.kde.enable =true;
  qt = {
    enable = true;
    platformTheme = {
      name = lib.mkDefault "gtk3";
    };
  };
}
