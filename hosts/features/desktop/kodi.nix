{
  config,
  pkgs,
  lib,
  ...
}:
let

  kodi_with_extentions = (
    with pkgs;
    (kodi-gbm.withPackages (
      p: with p; [
        inputstreamhelper
        inputstream-adaptive
        inputstream-ffmpegdirect
        inputstream-rtmp
        vfs-libarchive
        vfs-rar

        jellyfin
        web-viewer
      ]
    ))
    ++ [
      pkgs.kodiAddons-web-viewer
    ]
  );
in
{

  # Service for autostart
  services.cage.user = "kodi";
  services.cage.program = "${kodi_with_extentions}/bin/kodi-standalone";
  services.cage.enable = true;

  # Allow kodi access from other devices
  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };
}
