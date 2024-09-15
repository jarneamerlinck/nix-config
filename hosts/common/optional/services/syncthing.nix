# Auto-generated using compose2nix v0.2.3-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.oci-containers.containers."syncthing" = {
    image = "syncthing/syncthing";
    environment = {
      "PGID" = "100";
      "PUID" = "1442";
    };
    volumes = [
      "/data/sync/:/var/syncthing/:rw"
    ];
    ports = [
      "8384:8384/tcp"
      "22000:22000/tcp"
      "22000:22000/udp"
      "21027:21027/udp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--hostname=atlas"
      "--network-alias=syncthing"
      "--network=syncthing_default"
    ];
  };
  systemd.services."docker-syncthing" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-syncthing_default.service"
    ];
    requires = [
      "docker-network-syncthing_default.service"
    ];
    partOf = [
      "docker-compose-syncthing-root.target"
    ];
    wantedBy = [
      "docker-compose-syncthing-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-syncthing_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f syncthing_default";
    };
    script = ''
      docker network inspect syncthing_default || docker network create syncthing_default
    '';
    partOf = [ "docker-compose-syncthing-root.target" ];
    wantedBy = [ "docker-compose-syncthing-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-syncthing-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
