{
  config,
  pkgs,
  lib,
  ...
}:
{

  services.cage.user = "kodi";
  services.cage.program = "${pkgs.kodi-gbm}/bin/kodi-standalone";
  services.cage.enable = true;

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
}
