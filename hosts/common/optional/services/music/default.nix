{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    picard
  ];

}
