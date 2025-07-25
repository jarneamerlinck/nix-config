{
  pkgs,
  lib,
  config,
  ...
}:

{
  sops.secrets."music/env" = {
    sopsFile = ../../../../${config.networking.hostName}/secrets.yml;

    neededForUsers = true;
  };
  # Containers
  virtualisation.oci-containers.containers."music-navidrome" = {
    image = "deluan/navidrome:0.55.2";

    environmentFiles = [
      "/run/secrets-for-users/music/env"
    ];
    volumes = [
      "/data/docker/navidrome/:/data:rw"
      "/data/docker/downloader/storage/media/music/:/music:ro"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.navidrome-rtr.entrypoints" = "https";
      "traefik.http.routers.navidrome-rtr.rule" = "Host(`music.ko0.net`)";
      "traefik.http.routers.navidrome-rtr.service" = "navidrome-svc";
      "traefik.http.routers.navidrome-rtr.tls" = "true";
      "traefik.http.routers.navidrome-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.navidrome-svc.loadbalancer.server.port" = "4533";
    };
    user = "1442:100";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=navidrome"
      "--network=frontend"
    ];
  };
  systemd.services."docker-music-navidrome" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    partOf = [
      "docker-compose-music-root.target"
    ];
    wantedBy = [
      "docker-compose-music-root.target"
    ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-music-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
