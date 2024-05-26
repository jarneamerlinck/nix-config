{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    perl538Packages.MusicBrainz
  ];

}
