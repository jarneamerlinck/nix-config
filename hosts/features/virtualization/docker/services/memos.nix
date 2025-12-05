{
  pkgs,
  lib,
  config,
  ...
}:
let
  url = "notes.ko0.net";

in
{

  virtualisation.oci-containers.containers."memos-memos" = {
    image = "docker.io/neosmemo/memos:0.25.2";

    volumes = [ "/data/docker/docs/memos:/var/opt/memos" ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.memos-rtr.entrypoints" = "https";
      "traefik.http.routers.memos-rtr.rule" = "Host(`${url}`)";
      "traefik.http.routers.memos-rtr.service" = "memos-svc";
      "traefik.http.routers.memos-rtr.tls" = "true";
      "traefik.http.routers.memos-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.memos-svc.loadbalancer.server.port" = "5230";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=frontend"
      "--network=frontend"
    ];
  };

  # Services
  systemd.services."docker-memos-memos" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-frontend.service" ];
    requires = [ "docker-network-frontend.service" ];
    partOf = [ "docker-compose-memos-root.target" ];
    wantedBy = [ "docker-compose-memos-root-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-memos-root" = {
    unitConfig = {
      Description = "Root target generated with the template from compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
