{ pkgs, lib, config, ... }:

{
  sops.secrets."recipes/env" = {
    sopsFile = ../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };
  # Containers
  virtualisation.oci-containers.containers."tandoor-db_recipes" = {
    image = "postgres:16-alpine";
    environmentFiles = [
      "/run/secrets-for-users/recipes/env"
    ];
    volumes = [
      "/data/docker/tandoor/postgresql:/var/lib/postgresql/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=db_recipes"
      "--network=tandoor_tandoor"
    ];
  };
  systemd.services."docker-tandoor-db_recipes" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-tandoor_tandoor.service"
    ];
    requires = [
      "docker-network-tandoor_tandoor.service"
    ];
    partOf = [
      "docker-compose-tandoor-root.target"
    ];
    wantedBy = [
      "docker-compose-tandoor-root.target"
    ];
  };
  virtualisation.oci-containers.containers."tandoor-nginx_recipes" = {
    image = "nginx:1.27.3-alpine";
    environmentFiles = [
      "/run/secrets-for-users/recipes/env"
    ];
    volumes = [
      "/data/docker/tandoor/mediafiles:/media:ro"
      "tandoor_nginx_config:/etc/nginx/conf.d:ro"
      "tandoor_staticfiles:/static:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.tandoor-rtr.entrypoints" = "https";
      "traefik.http.routers.tandoor-rtr.rule" = "Host(`recipes.ko0.net`)";
      "traefik.http.routers.tandoor-rtr.service" = "tandoor-svc";
      "traefik.http.routers.tandoor-rtr.tls" = "true";
      "traefik.http.routers.tandoor-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.tandoor-svc.loadbalancer.server.port" = "80";
    };
    dependsOn = [
      "tandoor-web_recipes"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=nginx_recipes"
      "--network=frontend"
      "--network=tandoor_tandoor"
    ];
  };
  systemd.services."docker-tandoor-nginx_recipes" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-tandoor_tandoor.service"
      "docker-volume-tandoor_nginx_config.service"
      "docker-volume-tandoor_staticfiles.service"
    ];
    requires = [
      "docker-network-tandoor_tandoor.service"
      "docker-volume-tandoor_nginx_config.service"
      "docker-volume-tandoor_staticfiles.service"
    ];
    partOf = [
      "docker-compose-tandoor-root.target"
    ];
    wantedBy = [
      "docker-compose-tandoor-root.target"
    ];
  };
  virtualisation.oci-containers.containers."tandoor-web_recipes" = {
    image = "vabene1111/recipes:1.5.24";
    volumes = [
      "/data/docker/tandoor/mediafiles:/opt/recipes/mediafiles:rw"
      "tandoor_nginx_config:/opt/recipes/nginx/conf.d:rw"
      "tandoor_staticfiles:/opt/recipes/staticfiles:rw"
    ];
    dependsOn = [
      "tandoor-db_recipes"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=web_recipes"
      "--network=tandoor_tandoor"
    ];
  };
  systemd.services."docker-tandoor-web_recipes" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-tandoor_tandoor.service"
      "docker-volume-tandoor_nginx_config.service"
      "docker-volume-tandoor_staticfiles.service"
    ];
    requires = [
      "docker-network-tandoor_tandoor.service"
      "docker-volume-tandoor_nginx_config.service"
      "docker-volume-tandoor_staticfiles.service"
    ];
    partOf = [
      "docker-compose-tandoor-root.target"
    ];
    wantedBy = [
      "docker-compose-tandoor-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-tandoor_tandoor" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f tandoor_tandoor";
    };
    script = ''
      docker network inspect tandoor_tandoor || docker network create tandoor_tandoor
    '';
    partOf = [ "docker-compose-tandoor-root.target" ];
    wantedBy = [ "docker-compose-tandoor-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-tandoor_nginx_config" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect tandoor_nginx_config || docker volume create tandoor_nginx_config
    '';
    partOf = [ "docker-compose-tandoor-root.target" ];
    wantedBy = [ "docker-compose-tandoor-root.target" ];
  };
  systemd.services."docker-volume-tandoor_staticfiles" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect tandoor_staticfiles || docker volume create tandoor_staticfiles
    '';
    partOf = [ "docker-compose-tandoor-root.target" ];
    wantedBy = [ "docker-compose-tandoor-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-tandoor-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
