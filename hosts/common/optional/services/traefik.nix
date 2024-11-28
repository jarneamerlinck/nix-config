{ pkgs, lib, config, ... }:
{

  sops.secrets."traefik/env" = {
    sopsFile = ../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };
  # Containers
  virtualisation.oci-containers.containers."traefik" = {
  image = "traefik:v3.2.1";
    environmentFiles = [
      "/run/secrets-for-users/traefik/env"
    ];
    volumes = [
      "/data/docker/traefik/letsencrypt:/letsencrypt:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    ports = [
      # "80:80/tcp"
      "443:443/tcp"
      "8080:8080/tcp"
    ];
    cmd = [
      "--api.insecure=true"
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"
      "--entryPoints.http.address=:80"
      "--entryPoints.https.address=:443"
      "--certificatesresolvers.cloudflare.acme.dnschallenge=true"
      "--certificatesresolvers.cloudflare.acme.dnschallenge.provider=cloudflare"
      "--certificatesresolvers.cloudflare.acme.email=jarneamerlinck@pm.me"
      "--certificatesresolvers.cloudflare.acme.storage=/letsencrypt/acme.json"
    ];


    labels = {
      "traefik.enable"="true";
      # "traefik.http.routers.traefik_https.rule"="Host(`vm1.ko0.net`)";
      # "traefik.http.routers.traefik_https.entrypoints"="websecure";
      # "traefik.http.routers.traefik_https.tls.certresolver"="cloudflare";
      # "traefik.http.routers.traefik_https.tls"="false";
      # "traefik.http.services.traefik_https.loadbalancer.server.port"="8080";
      # "traefik.http.services.traefik_https.loadbalancer.server.scheme"="http";

      "traefik.http.routers.traefik_https.rule"="Host(`vm1.ko0.net`)";
      "traefik.http.routers.traefik_https.entrypoints"="https";
      "traefik.http.routers.traefik_https.tls.certresolver"="cloudflare";
      "traefik.http.routers.traefik_https.tls"="false";
      "traefik.http.services.calibre.loadbalancer.server.port"="8080";

      # "traefik.http.middlewares.https_redirect.redirectscheme.scheme"="https";
      # "traefik.http.middlewares.https_redirect.redirectscheme.permanent"="true";
      # "traefik.http.routers.http_catchall.rule"="HostRegexp(`{any:.+}`) && !PathPrefix(`/.well-known/acme-challenge/`)";
      #
      # "traefik.http.routers.http_catchall.entrypoints"="http";
      # "traefik.http.routers.http_catchall.middlewares"="https_redirect";

    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=traefik"
      "--network=frontend"
    ];
  };
  systemd.services."docker-traefik" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [
      "docker-network-frontend.service"
    ];
    requires = [
      "docker-network-frontend.service"
    ];
    partOf = [
      "docker-compose-traefik-root.target"
    ];
    wantedBy = [
      "docker-compose-traefik-root.target"
    ];
  };

  # Networks
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

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-traefik-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
