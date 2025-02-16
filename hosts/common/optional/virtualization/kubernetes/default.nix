{ config, pkgs, ... }:

{
  imports = [
    ./prometheus.nix
    ./haproxy.nix
  ];

}
