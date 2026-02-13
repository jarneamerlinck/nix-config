{
  pkgs,
  lib,
  config,
  ...
}:
let
  url = "chat.ko0.net";

in
{

  sops.secrets."openwebui/env" = {
    sopsFile = ../../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."mcpo/config.json" = {
    sopsFile = ../../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };
  # Containers
  virtualisation.oci-containers.containers."chat-openwebui" = {
    image = "ghcr.io/open-webui/open-webui:0.8.0";
    environmentFiles = [ "/run/secrets-for-users/openwebui/env" ];

    environment = {
      "WEBUI_URL" = "https://${url}";
      "OLLAMA_BASE_URL" = "http://ollama:11434";
      "ENABLE_ADMIN_CHAT_ACCESS" = "false";
      "ENABLE_SIGNUP" = "false";
      "ENABLE_CHANNELS" = "true";
      "ENABLE_OLLAMA_API" = "true";
      "ENABLE_WEB_SEARCH" = "true";
      "WEB_SEARCH_ENGINE" = "duckduckgo";
    };
    volumes = [ "/data/docker/chat/openwebui/:/app/backend/data" ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.chat-rtr.entrypoints" = "https";
      "traefik.http.routers.chat-rtr.rule" = "Host(`${url}`)";
      "traefik.http.routers.chat-rtr.service" = "chat-svc";
      "traefik.http.routers.chat-rtr.tls" = "true";
      "traefik.http.routers.chat-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.chat-svc.loadbalancer.server.port" = "8080";
    };
    dependsOn = [ "ollama" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=chat"
      "--network=chat"
      "--network=frontend"
    ];
  };

  virtualisation.oci-containers.containers."ollama" = {
    image = "ollama/ollama:0.16.0";
    volumes = [ "/data/docker/chat/ollama/:/root/.ollama" ];
    environment = {
      "chat_HOST" = "0.0.0.0";
      "chat_KEEP_ALIVE" = "5m";
      "chat_FLASH_ATTENTION" = "0";
      "chat_GIN_MODE" = "release";
    };
    log-driver = "journald";
    extraOptions = [
      "--device=nvidia.com/gpu=all"
      "--network-alias=chat"
      "--network=chat"
    ];
  };

  virtualisation.oci-containers.containers."mcpo" = {
    image = "ghcr.io/jarneamerlinck/mcpo:main@sha256:e40e14e1f36ac3c137f27b15c5f2f5a9edee19fb3b2c044a12e48b4ef04d299d";
    volumes = [ "${config.sops.secrets."mcpo/config.json".path}:/config.json" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=chat"
      "--network=chat"
      "--network=source_code"
      "--network=bookmark"
    ];
  };
  # Networks
  systemd.services."docker-network-chat" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f chat";
    };
    script = ''
      docker network inspect chat || docker network create chat
    '';
    partOf = [ "docker-compose-chat-root.target" ];
    wantedBy = [ "docker-compose-chat-root.target" ];
  };

  # Services
  systemd.services."docker-chat-openwebui" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-chat.service" ];
    requires = [ "docker-network-chat.service" ];
    partOf = [ "docker-compose-chat-root.target" ];
    wantedBy = [ "docker-compose-chat-root-root.target" ];
  };

  systemd.services."docker-ollama" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [ "docker-network-chat.service" ];
    requires = [ "docker-network-chat.service" ];
    partOf = [ "docker-compose-chat-root.target" ];
    wantedBy = [ "docker-compose-chat-root-root.target" ];
  };

  systemd.services."docker-mcpo" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-chat.service"
      "docker-network-source_code.service"
      "docker-network-bookmark.service"
    ];
    requires = [
      "docker-network-chat.service"
      "docker-network-source_code.service"
      "docker-network-bookmark.service"
    ];
    partOf = [ "docker-compose-chat-root.target" ];
    wantedBy = [ "docker-compose-chat-root-root.target" ];
  };
  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-chat-root" = {
    unitConfig = {
      Description = "Root target generated with the template from compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
