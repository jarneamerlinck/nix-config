{
  config,
  pkgs,
  ...
}:
{
  home.packages  = with pkgs.wallpapers; [
    framework-12-grid-16-10
    linkin-park-logo-4k-qu-16-10
    linkin-park-burning-in-the-skies-r1-16-10
    sunset-over-the-peaks-jx-16-10
    flare-lines-vr-16-10
    star-trails-5k-i0-16-10
    red-dragon-sky-16-10
  ];
  services.swww = {
    enable = true;
  };

}
