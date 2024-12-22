# Auto-generated using compose2nix v0.3.2-pre.
{ pkgs, lib, config,  ... }:

{

  sops.secrets."photos/env" = {
    sopsFile = ../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."photos/db" = {
    sopsFile = ../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  # Containers

  virtualisation.oci-containers.containers."photos-photoprism" = {
    image = "photoprism/photoprism:240915";
    environmentFiles = [
      "/run/secrets-for-users/photos/env"
    ];
    volumes = [
      "/data/docker/photoprism/original:/photoprism/originals:rw"
      "/data/docker/photoprism/storage:/photoprism/storage:rw"
      # "/data/docker/photoprism/import:/photoprism/import:rw"
      "/data/sync/photos/:/photoprism/import/photos/jarne:ro"
      "/data/backup/google_photos:/photoprism/import/photos/google_photos:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.photos-rtr.entrypoints" = "https";
      "traefik.http.routers.photos-rtr.rule" = "Host(`photos.ko0.net`)";
      "traefik.http.routers.photos-rtr.service" = "photos-svc";
      "traefik.http.routers.photos-rtr.tls" = "true";
      "traefik.http.routers.photos-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.photos-svc.loadbalancer.server.port" = "2342";
    };
    dependsOn = [
      "photos-mariadb"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=photoprism"
      "--network=frontend"
      "--network=photos_photos"
      "--security-opt=apparmor:unconfined"
      "--security-opt=seccomp:unconfined"
    ];
  };
  virtualisation.oci-containers.containers."photos-mariadb" = {
    image = "mariadb:11";
    environmentFiles = [
      "/run/secrets-for-users/photos/db"
    ];
    volumes = [
      "/data/docker/photoprism/database:/var/lib/mysql:rw"
    ];
    cmd = [ "--innodb-buffer-pool-size=512M" "--transaction-isolation=READ-COMMITTED" "--character-set-server=utf8mb4" "--collation-server=utf8mb4_unicode_ci" "--max-connections=512" "--innodb-rollback-on-timeout=OFF" "--innodb-lock-wait-timeout=120" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mariadb"
      "--network=photos_photos"
      "--security-opt=apparmor:unconfined"
      "--security-opt=seccomp:unconfined"
    ];
  };
  systemd.services."docker-photos-mariadb" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-photos_photos.service"
    ];
    requires = [
      "docker-network-photos_photos.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };
  systemd.services."docker-photos-photoprism" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "docker-network-photos_photos.service"
    ];
    requires = [
      "docker-network-photos_photos.service"
    ];
    partOf = [
      "docker-compose-photos-root.target"
    ];
    wantedBy = [
      "docker-compose-photos-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-photos_photos" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f photos_photos";
    };
    script = ''
      docker network inspect photos_photos || docker network create photos_photos
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