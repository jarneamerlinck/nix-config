{ pkgs, lib, ... }:
let
  kodi-with-addons = pkgs.kodi-wayland.withPackages (
    kodiPkgs: with kodiPkgs; [
      inputstream-adaptive
      jellyfin
      bluetooth-manager
    ]
  );
in
{
  services.xserver.enable = false;
  # Define a user account
  services.cage.user = "kodi";
  services.cage.extraArguments = [
    "-m"
    "last"
  ];
  services.getty.autologinUser = "kodi";
  services.cage.program = "${kodi-with-addons}/bin/kodi-standalone";
  services.cage.enable = true;
  users.users.kodi = {
    isNormalUser = true;
    extraGroups = [
      "uucp"
      "audio"
      "input"
      "video"
      "render"
    ];
  };
}
