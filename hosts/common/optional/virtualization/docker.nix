{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    distrobox
  ];
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  imports = [
    ../../services/docker-image-notifier.nix
  ];

}
