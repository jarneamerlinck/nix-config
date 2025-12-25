{ pkgs, ... }:
{

  environment.systemPackages = [
    (pkgs.kodi.withPackages (
      kodiPkgs: with kodiPkgs; [
        jellyfin
      ]
    ))
  ];

  services.xserver.enable = false;
  services.xserver.desktopManager.kodi.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "kodi";

  services.xserver.displayManager.lightdm.greeter.enable = false;

  # Define a user account

  users.extraUsers.kodi.isNormalUser = true;
  services.cage.user = "kodi";
  services.cage.program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
  services.cage.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };

}
