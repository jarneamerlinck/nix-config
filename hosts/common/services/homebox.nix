# Auto-generated using compose2nix v0.2.3-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.oci-containers.containers."homebox-homebox" = {
    image = "ghcr.io/sysadminsmedia/homebox:0.18.0";
    environment = {
      "HBOX_LOG_FORMAT" = "text";
      "HBOX_LOG_LEVEL" = "info";
      "HBOX_OPTIONS_ALLOW_REGISTRATION" = "false";
      "HBOX_WEB_MAX_UPLOAD_SIZE" = "100";
    };
    volumes = [
      "/data/docker/homebox:/data:rw"
    ];
    # ports = [
    #   "3100:7745/tcp"
    # ];

    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.homebox-rtr.entrypoints" = "https";
      "traefik.http.routers.homebox-rtr.rule" = "Host(`inventory.ko0.net`)";
      "traefik.http.routers.homebox-rtr.service" = "homebox-svc";
      "traefik.http.routers.homebox-rtr.tls" = "true";
      "traefik.http.routers.homebox-rtr.tls.certresolver" = "cloudflare";
      "traefik.http.services.homebox-svc.loadbalancer.server.port" = "7745";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=homebox"
      "--network=homebox"
      "--network=frontend"
    ];
  };
  systemd.services."docker-homebox-homebox" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-homebox.service"
      "docker-network-frontend.service"
    ];
    requires = [
      "docker-network-homebox.service"
      "docker-network-frontend.service"
    ];
    partOf = [
      "docker-compose-homebox-root.target"
    ];
    wantedBy = [
      "docker-compose-homebox-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-homebox" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f homebox";
    };
    script = ''
      docker network inspect homebox || docker network create homebox
    '';
    partOf = [ "docker-compose-homebox-root.target" ];
    wantedBy = [ "docker-compose-homebox-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-homebox-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
