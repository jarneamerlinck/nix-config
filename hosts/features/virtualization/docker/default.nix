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
}
