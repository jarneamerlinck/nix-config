{
  config,
  pkgs,
  lib,
  ...
}:
{
  users.extraUsers.kodi.isNormalUser = true;
  users.users.kodi.extraGroups = [
    "data"
    "video"
    "audio"
    "input"
  ];
  services.cage.user = "kodi";
  services.cage.program = "${pkgs.kodi}/bin/kodi-standalone";
  services.cage.enable = true;

  # hardware.opengl = {
  #   enable = true;
  #   extraPackages = with pkgs; [ libva ];
  # };

  environment.systemPackages = [
    (pkgs.kodi.passthru.withPackages (
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
