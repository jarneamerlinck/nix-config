{ config, pkgs, ... }:

{
  imports = [
    ./prometheus.nix
    ./secrets.nix
    ./certs.nix
    ./storage.nix
  ];

}
