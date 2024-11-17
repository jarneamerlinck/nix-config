# Auto-generated using compose2nix v0.2.3-pre.
{ pkgs, lib, ... }:

{

  # Containers
  virtualisation.oci-containers.containers."portainer" = {
    image = "portainer/portainer-ce:2.21.1";
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:rw"
      "portainer_portainer_data:/data:rw"
    ];
    ports = [
      "8000:8000/tcp"
      "9443:9443/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=portainer"
      "--network=portainer_default"
    ];
  };
  systemd.services."docker-portainer" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-portainer_default.service"
      "docker-volume-portainer_portainer_data.service"
    ];
    requires = [
      "docker-network-portainer_default.service"
      "docker-volume-portainer_portainer_data.service"
    ];
    partOf = [
      "docker-compose-portainer-root.target"
    ];
    wantedBy = [
      "docker-compose-portainer-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-portainer_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f portainer_default";
    };
    script = ''
      docker network inspect portainer_default || docker network create portainer_default
    '';
    partOf = [ "docker-compose-portainer-root.target" ];
    wantedBy = [ "docker-compose-portainer-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-portainer_portainer_data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect portainer_portainer_data || docker volume create portainer_portainer_data
    '';
    partOf = [ "docker-compose-portainer-root.target" ];
    wantedBy = [ "docker-compose-portainer-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-portainer-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
