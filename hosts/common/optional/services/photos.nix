# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, config,  ... }:

{

  sops.secrets."images/env" = {
    sopsFile = ../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };


  virtualisation.oci-containers.containers."immich_server" = {
    image = "ghcr.io/immich-app/immich-server:v1.122.3";
    environmentFiles = [
      "/run/secrets-for-users/images/env"
    ];
    volumes = [
      "/data/docker/immich/data:/usr/src/app/upload:rw"
      "/data/sync/other_users/sofie:/photos_external/sofie:ro"
      "/data/sync/photos:/photos_external/jarne/photos:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.immich-rtr.entrypoints" = "https";
      "traefik.http.routers.immich-rtr.rule" = "Host(`photos.ko0.net`)";
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
      "--network-alias=immich-server"
      "--network=frontend"
      "--network=photos_immich"
    ];
  };
  systemd.services."docker-immich_server" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-photos_immich.service"
    ];
    requires = [
      "docker-network-photos_immich.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };


  # Containers
  virtualisation.oci-containers.containers."immich_machine_learning" = {
    image = "ghcr.io/immich-app/immich-machine-learning:v1.122.3";
    environmentFiles = [
      "/run/secrets-for-users/images/env"
    ];
    volumes = [
      "photos_model-cache:/cache:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=immich-machine-learning"
      "--network=photos_immich"
    ];
  };
  systemd.services."docker-immich_machine_learning" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-photos_immich.service"
      "docker-volume-photos_model-cache.service"
    ];
    requires = [
      "docker-network-photos_immich.service"
      "docker-volume-photos_model-cache.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };
  virtualisation.oci-containers.containers."immich_postgres" = {
    image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
    environmentFiles = [
      "/run/secrets-for-users/images/env"
    ];
    volumes = [
      "/data/docker/immich/postgress:/var/lib/postgresql/data:rw"
    ];
    cmd = [ "postgres" "-c" "shared_preload_libraries=vectors.so" "-c" "search_path=\"$user\", public, vectors" "-c" "logging_collector=on" "-c" "max_wal_size=2GB" "-c" "shared_buffers=512MB" "-c" "wal_compression=on" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=database"
      "--network=photos_immich"
    ];
  };
  systemd.services."docker-immich_postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-photos_immich.service"
    ];
    requires = [
      "docker-network-photos_immich.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };
  virtualisation.oci-containers.containers."immich_redis" = {
    image = "docker.io/redis:6.2-alpine@sha256:eaba718fecd1196d88533de7ba49bf903ad33664a92debb24660a922ecd9cac8";
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=redis-cli ping || exit 1"
      "--network-alias=redis"
      "--network=photos_immich"
    ];
  };
  systemd.services."docker-immich_redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-photos_immich.service"
    ];
    requires = [
      "docker-network-photos_immich.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-photos_immich" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f photos_immich";
    };
    script = ''
      docker network inspect photos_immich || docker network create photos_immich
    '';
    partOf = [ "docker-compose-photos-root.target" ];
    wantedBy = [ "docker-compose-photos-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-photos_model-cache" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect photos_model-cache || docker volume create photos_model-cache
    '';
    partOf = [ "docker-compose-photos-root.target" ];
    wantedBy = [ "docker-compose-photos-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-photos-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
