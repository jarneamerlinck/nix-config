{ pkgs, lib, config, ... }:
let
  url = "bookmarks.ko0.net";
  shared_env = {
    "NEXTAUTH_URL" = "https://bookmarks.ko0.net";
    "MEILI_NO_ANALYTICS" = "true";
    "MEILI_ADDR" = "http://bookmarks-meilisearch:7700";
    "BROWSER_WEB_URL" = "http://bookmarks-chrome:9222";
    "DATA_DIR" = "/data";
    "OLLAMA_BASE_URL" = "http://ollama:11434";
  };
  karakeep_version = "0.26.0";

in {

  sops.secrets."bookmarks/env" = {
    sopsFile = ../../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  # Containers
  virtualisation.oci-containers.containers."bookmarks-karakeep" = {
    image = "ghcr.io/karakeep-app/karakeep:${karakeep_version}";
    environmentFiles = [ "/run/secrets-for-users/bookmarks/env" ];

    environment = shared_env;
    volumes = [ "/data/docker/bookmarks/data/:/data" ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.bookmarks-rtr.entrypoints" = "https";
      "traefik.http.routers.bookmarks-rtr.rule" = "Host(`${url}`)";
      "traefik.http.routers.bookmarks-rtr.service" = "bookmarks-svc";
      "traefik.http.routers.bookmarks-rtr.tls" = "true";
      "traefik.http.routers.bookmarks-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.bookmarks-svc.loadbalancer.server.port" = "3000";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=bookmarks"
      "--network=bookmarks"
      "--network=frontend"
      "--network=chat"
    ];
  };

  virtualisation.oci-containers.containers."bookmarks-chrome" = {
    image = "gcr.io/zenika-hub/alpine-chrome:124";
    environmentFiles = [ "/run/secrets-for-users/bookmarks/env" ];
    environment = shared_env;
    log-driver = "journald";
    extraOptions = [ "--network-alias=bookmarks" "--network=bookmarks" ];

    cmd = [
      "--no-sandbox"
      "--disable-gpu"
      "--disable-dev-shm-usage"
      "--remote-debugging-address=0.0.0.0"
      "--remote-debugging-port=9222"
      "--hide-scrollbars"
    ];
  };

  virtualisation.oci-containers.containers."bookmarks-meilisearch" = {
    image = "getmeili/meilisearch:v1.13.3";
    environmentFiles = [ "/run/secrets-for-users/bookmarks/env" ];
    environment = shared_env;
    volumes = [ "/data/docker/bookmarks/meilisearch/:/meili_data" ];
    log-driver = "journald";
    extraOptions = [ "--network-alias=bookmarks" "--network=bookmarks" ];

  };

  # Networks
  systemd.services."docker-network-bookmarks" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f bookmarks";
    };
    script = ''
      docker network inspect bookmarks || docker network create bookmarks
    '';
    partOf = [ "docker-compose-bookmarks-root.target" ];
    wantedBy = [ "docker-compose-bookmarks-root.target" ];
  };

  # Services
  systemd.services."docker-bookmarks-karakeep" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-bookmarks.service"
      "docker-network-chat.service"
      "docker-network-frontend.service"
    ];
    requires = [
      "docker-network-bookmarks.service"
      "docker-network-chat.service"
      "docker-network-frontend.service"
    ];
    partOf = [ "docker-compose-bookmarks-root.target" ];
    wantedBy = [ "docker-compose-bookmarks-root-root.target" ];
  };

  systemd.services."docker-bookmarks-chrome" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-bookmarks.service" ];
    requires = [ "docker-network-bookmarks.service" ];
    partOf = [ "docker-compose-bookmarks-root.target" ];
    wantedBy = [ "docker-compose-bookmarks-root-root.target" ];
  };

  systemd.services."docker-bookmarks-meilisearch" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-bookmarks.service" ];
    requires = [ "docker-network-bookmarks.service" ];
    partOf = [ "docker-compose-bookmarks-root.target" ];
    wantedBy = [ "docker-compose-bookmarks-root-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-bookmarks-root" = {
    unitConfig = {
      Description = "Root target generated with the template from compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
