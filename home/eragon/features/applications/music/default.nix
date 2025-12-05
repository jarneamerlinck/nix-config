{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alsa-utils
    yt-dlp
    audacity
    picard
    feishin
  ];
}
