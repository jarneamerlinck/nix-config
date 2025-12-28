{
  pkgs,
  ...
}:
{

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];

  };
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };
  environment.systemPackages = with pkgs; [
    gamescope-wsi # HDR won't work without this
    protonup-qt
  ];

}
