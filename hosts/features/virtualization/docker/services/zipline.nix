{
  pkgs,
  lib,
  config,
  ...
}:
let
  url = "share.ko0.net";
in

{

  sops.secrets."zipline/env" = {
    sopsFile = ../../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  # Containers
  virtualisation.oci-containers.containers."zipline-zipline" = {
    image = "ghcr.io/diced/zipline:4.1.2";
    environmentFiles = [
      "/run/secrets-for-users/zipline/env"
    ];

    volumes = [
      "/data/docker/zipline/uploads:/zipline/uploads"
      "/data/docker/zipline/public:/zipline/public"
      "/data/docker/zipline/themes:/zipline/themes"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.zipline-rtr.entrypoints" = "https";
      "traefik.http.routers.zipline-rtr.rule" = "Host(`${url}`)";
      "traefik.http.routers.zipline-rtr.service" = "zipline-svc";
      "traefik.http.routers.zipline-rtr.tls" = "true";
      "traefik.http.routers.zipline-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.zipline-svc.loadbalancer.server.port" = "3000";
    };
    log-driver = "journald";

    dependsOn = [
      "zipline-postgresql"
    ];
    extraOptions = [
      "--health-cmd=[\"wget\", \"-q\", \"--spider\", \"http://0.0.0.0:3000/api/healthcheck\"]"
      "--health-interval=15s"
      "--health-retries=2"
      "--health-timeout=2s"
      "--network-alias=zipline"
      "--network=zipline"
      "--network=frontend"
    ];
  };

  virtualisation.oci-containers.containers."zipline-postgresql" = {
    image = "postgres:16";
    environmentFiles = [
      "/run/secrets-for-users/zipline/env"
    ];
    log-driver = "journald";

    volumes = [
      "/data/docker/zipline/db:/var/lib/postgresql/data"
    ];
    extraOptions = [
      "--health-cmd=[\"pg_isready\", \"-U\", \"zipline\"]"
      "--health-interval=10s"
      "--health-retries=5"
      "--health-timeout=5s"
      "--network-alias=postgresql"
      "--network=zipline"
    ];
  };

  # Networks
  systemd.services."docker-network-zipline" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f zipline";
    };
    script = ''
      docker network inspect zipline || docker network create zipline
    '';
    partOf = [ "docker-compose-zipline-root.target" ];
    wantedBy = [ "docker-compose-zipline-root.target" ];
  };

  # Services
  systemd.services."docker-zipline-zipline" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-zipline.service"
      "docker-network-frontend.service"
    ];
    requires = [
      "docker-network-zipline.service"
      "docker-network-frontend.service"
    ];
    partOf = [
      "docker-compose-zipline-root.target"
    ];
    wantedBy = [
      "docker-compose-zipline-root-root.target"
    ];
  };

  systemd.services."docker-zipline-postgresql" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-zipline.service"
    ];
    requires = [
      "docker-network-zipline.service"
    ];
    partOf = [
      "docker-compose-zipline-root.target"
    ];
    wantedBy = [
      "docker-compose-zipline-root-root.target"
    ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-zipline-root" = {
    unitConfig = {
      Description = "Root target generated with the template from compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
