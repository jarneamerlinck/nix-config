{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ distrobox ];
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";

  systemd.services."docker-network-frontend" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f frontend";
    };
    script = ''
      docker network inspect frontend || docker network create frontend
    '';
    partOf = [ "docker-compose-traefik-root.target" ];
    wantedBy = [ "docker-compose-traefik-root.target" ];
  };
  nixpkgs.config.permittedInsecurePackages = [
    "docker-28.5.2"
    "incus-lts-6.0.6-unstable-2026-03-27"
    "incus-lts-client-6.0.6-unstable-2026-03-27"
  ];
}
