{ config, pkgs, ... }:

{
  imports = [
    ./prometheus.nix
    ./haproxy.nix
    ./cert-manager.nix
  ];

}
