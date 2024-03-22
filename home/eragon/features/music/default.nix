{ pkgs, ... }:
{
  home.packages = with pkgs;
  [
    alsa-utils
    yt-dlp
    audacity
  ];
  services.fluidsynth = {
    enable = true;
    soundService = "pipewire-pulse";
    extraOptions = [
      "-g 2"
    ];
  };
}
