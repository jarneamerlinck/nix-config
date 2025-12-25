{
  config,
  pkgs,
  lib,
  ...
}:
{

  # Kodi package
  environment.systemPackages = [
    (pkgs.kodi-gbm.passthru.withPackages (
      kodiPkgs: with kodiPkgs; [
        inputstreamhelper
        inputstream-adaptive
        inputstream-ffmpegdirect
        inputstream-rtmp
        vfs-libarchive
        vfs-rar
        youtube
      ]
    ))
  ];

  # Service for autostart
  services.cage.user = "kodi";
  services.cage.program = "${pkgs.kodi-gbm}/bin/kodi-standalone";
  services.cage.enable = true;

  # Allow kodi access from other devices
  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };
}
