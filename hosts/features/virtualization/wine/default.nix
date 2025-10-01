{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stable # 32 and 64 bit support
    winetricks
    wineWowPackages.waylandFull
  ];

}
