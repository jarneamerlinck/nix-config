# Auto-generated using compose2nix v0.2.3-pre.
{ pkgs, lib, ... }:

{
  # Containers
  virtualisation.oci-containers.containers."cloudflare-tunnel" = {
    image = "cloudflare/cloudflared:2023.2.1";
    environmentFiles = [
      "/data/docker/envs/.env_cf_tunnel"
    ];
    cmd = [ "tunnel" "--no-autoupdate" "run" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=cloudflaretunnel"
      "--network=frontend"
    ];
  };
  systemd.services."docker-cloudflare-tunnel" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-frontend.service"
    ];
    requires = [
      "docker-network-frontend.service"
    ];
    partOf = [
      "docker-compose-cloudflare-tunnel-root.target"
    ];
    wantedBy = [
      "docker-compose-cloudflare-tunnel-root.target"
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
    partOf = [ "docker-compose-cloudflare-tunnel-root.target" ];
    wantedBy = [ "docker-compose-cloudflare-tunnel-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-cloudflare-tunnel-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };

}
