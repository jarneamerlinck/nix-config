{ inputs, lib, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    openlens.openlens
  ];
}

