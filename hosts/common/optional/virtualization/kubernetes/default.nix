{ config, pkgs, ... }:

{
  imports = [
    ./prometheus.nix
    ./certs.nix
  ];

}
