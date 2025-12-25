{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  programs.kodi = {
    addonSettings = {
      # Disable automatic version checks
      "service.xbmc.versioncheck" = {
        versioncheck_enable = "false";
        upgrade_system = "false";
        upgrade_apt = "false";
      };
    };
  };
}
