{
  config,
  pkgs,
  lib,
  ...
}:
{

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
