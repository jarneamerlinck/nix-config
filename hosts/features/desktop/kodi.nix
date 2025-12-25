{ pkgs, ... }:
{

  environment.systemPackages = [
    (pkgs.kodi.withPackages (
      kodiPkgs: with kodiPkgs; [
        jellyfin
      ]
    ))
  ];

  # services.xserver.enable = false;
  # services.xserver.desktopManager.kodi.enable = false;
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "kodi";

  # services.xserver.displayManager.lightdm.greeter.enable = false;

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
