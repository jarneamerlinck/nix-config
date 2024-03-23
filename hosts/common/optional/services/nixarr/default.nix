{ config, pkgs, ... }:
{

  nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    mediaDir = "/data/media";
    stateDir = "/data/media/.state";
    };
}
