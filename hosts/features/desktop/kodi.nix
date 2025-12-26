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
        youtube

        jellyfin
        kodiAddons.web-viewer
      ]
    ))
  );
  # kodi_with_extentions = (
  #
  #   with pkgs;
  #   (kodi-gbm.withPackage (
  #     p: with p; [
  #       inputstreamhelper
  #       inputstream-adaptive
  #       inputstream-ffmpegdirect
  #       inputstream-rtmp
  #       vfs-libarchive
  #       vfs-rar
  #       youtube
  #
  #       jellyfin
  #     ]
  #   ))
  # );
in
{

  # Kodi package
  # environment.systemPackages = [
  #   (pkgs.kodi-gbm.passthru.withPackages (
  #     kodiPkgs: with kodiPkgs; [
  #     ]
  #   ))
  # ];

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
