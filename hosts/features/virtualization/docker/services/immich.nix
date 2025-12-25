{
  pkgs,
  lib,
  config,
  ...
}:
let
  url = "photos.ko0.net";

  version = "v2.4.1";
  upload_dir = "/data/docker/immich/data";
  db_dir = "/data/docker/immich/postgress";

  kiosk_url = "kiosk.ko0.net";
  kiosk_version = "0.29.1";
  kiosk_config_dir = "/data/docker/immich/extentions/kiosk";
in
{

  sops.secrets."immich/env" = {
    sopsFile = ../../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."immich/kiosk_config.yaml" = {
    sopsFile = ../../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
    mode = "0444";
    path = "${kiosk_config_dir}/config.yaml";
  };
  sops.secrets."immich/db.env" = {
    sopsFile = ../../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };
  # Containers
  virtualisation.oci-containers.containers."immich_server" = {
    image = "ghcr.io/immich-app/immich-server:${version}";
    environmentFiles = [ "/run/secrets-for-users/immich/env" ];

    environment = {
      "IMMICH_VERSION" = "${version}";
      "UPLOAD_LOCATION" = "${upload_dir}";
      "DB_DATA_LOCATION" = "${db_dir}";
    };
    volumes = [ "${upload_dir}:/data" ];
    labels = {
      "traefik.docker.network" = "frontend";
      "traefik.enable" = "true";
      "traefik.http.routers.immich-rtr.entrypoints" = "https";
      "traefik.http.routers.immich-rtr.rule" = "Host(`${url}`)";
      "traefik.http.routers.immich-rtr.service" = "immich-svc";
      "traefik.http.routers.immich-rtr.tls" = "true";
      "traefik.http.routers.immich-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.immich-svc.loadbalancer.server.port" = "2283";
    };
    dependsOn = [
      "immich_postgres"
      "immich_redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--device=nvidia.com/gpu=all"
      "--network-alias=immich-server"
      "--network=frontend"
      "--network=immich"
    ];
  };

  virtualisation.oci-containers.containers."immich_machine_learning" = {
    image = "ghcr.io/immich-app/immich-machine-learning:${version}-cuda";
    volumes = [
      "immich_model-cache:/cache:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--device=nvidia.com/gpu=all"
      "--network-alias=immich-machine-learning"
      "--network=immich"
    ];
  };

  virtualisation.oci-containers.containers."immich_postgres" = {
    image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:41eacbe83eca995561fe43814fd4891e16e39632806253848efaf04d3c8a8b84";
    environmentFiles = [ "/run/secrets-for-users/immich/db.env" ];
    volumes = [
      "${db_dir}:/var/lib/postgresql/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=database"
      "--network=immich"
      "--shm-size=134217728"
    ];
  };

  virtualisation.oci-containers.containers."immich_redis" = {
    image = "docker.io/valkey/valkey:8-bookworm@sha256:fea8b3e67b15729d4bb70589eb03367bab9ad1ee89c876f54327fc7c6e618571";
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=redis-cli ping || exit 1"
      "--network-alias=redis"
      "--network=immich"
    ];
  };
  virtualisation.oci-containers.containers."immich_kiosk" = {
    image = "ghcr.io/damongolding/immich-kiosk:${kiosk_version}";
    environment = {
      "LANG" = "en_GB";
      "TZ" = "Europe/Brussels";
    };
    volumes = [ "${kiosk_config_dir}/config.yaml:/config/config.yaml" ];
    labels = {
      "traefik.docker.network" = "frontend";
      "traefik.enable" = "true";
      "traefik.http.routers.immich_kiosk-rtr.entrypoints" = "https";
      "traefik.http.routers.immich_kiosk-rtr.rule" = "Host(`${kiosk_url}`)";
      "traefik.http.routers.immich_kiosk-rtr.service" = "immich_kiosk-svc";
      "traefik.http.routers.immich_kiosk-rtr.tls" = "true";
      "traefik.http.routers.immich_kiosk-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.immich_kiosk-svc.loadbalancer.server.port" = "3000";
    };
    # dependsOn = [
    #   "immich_server"
    # ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=immich_kiosk"
      "--network=frontend"
    ];
  };

  # Networks
  systemd.services."docker-network-immich" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f immich";
    };
    script = ''
      docker network inspect immich || docker network create immich
    '';
    partOf = [ "docker-compose-immich-root.target" ];
    wantedBy = [ "docker-compose-immich-root.target" ];
  };

  # Services
  systemd.services."docker-immich_server" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-immich.service"
    ];
    requires = [
      "docker-network-immich.service"
    ];
    partOf = [
      "docker-compose-immich-root.target"
    ];
    wantedBy = [
      "docker-compose-immich-root.target"
    ];
  };

  systemd.services."docker-immich_machine_learning" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;

    };
    after = [
      "docker-network-immich.service"
      "docker-volume-immich_model-cache.service"
    ];
    requires = [
      "docker-network-immich.service"
      "docker-volume-immich_model-cache.service"
    ];
    partOf = [
      "docker-compose-immich-root.target"
    ];
    wantedBy = [
      "docker-compose-immich-root.target"
    ];
  };

  systemd.services."docker-volume-immich_model-cache" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect immich_model-cache || docker volume create immich_model-cache
    '';
    partOf = [ "docker-compose-immich-root.target" ];
    wantedBy = [ "docker-compose-immich-root.target" ];
  };
  systemd.services."docker-immich_kiosk" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-immich.service"
    ];
    requires = [
      "docker-network-immich.service"
    ];
    partOf = [
      "docker-compose-immich-root.target"
    ];
    wantedBy = [
      "docker-compose-immich-root.target"
    ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-immich-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
