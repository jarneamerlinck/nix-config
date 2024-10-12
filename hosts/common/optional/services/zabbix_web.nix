# Auto-generated using compose2nix v0.2.3-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  virtualisation.oci-containers.containers."zabbix-web" = {
    image = "zabbix/zabbix-web-nginx-mysql:alpine-6.4.19";
    # volumes = [
    #   "/data/docker/zabbix-web:/data:rw"
    # ];

    environmentFiles = [
      "/data/docker/envs/.env_zabbix_web"
    ];



    ports = [
      "8080:8080/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=zabbix"
      "--network=zabbix"
      "--network=frontend"
    ];
  };
  systemd.services."docker-zabbix-web" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    after = [
      "docker-network-zabbix.service"
      "docker-network-frontend.service"
    ];
    requires = [
      "docker-network-zabbix.service"
      "docker-network-frontend.service"
    ];
    partOf = [
      "docker-compose-zabbix-web-root.target"
    ];
    wantedBy = [
      "docker-compose-zabbix-web-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-zabbix" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f zabbix-web";
    };
    script = ''
      docker network inspect zabbix-web || docker network create zabbix-web
    '';
    partOf = [ "docker-compose-zabbix-web-root.target" ];
    wantedBy = [ "docker-compose-zabbix-web-root.target" ];
  };

  systemd.services."docker-network-frontend" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # ExecStop = "docker network rm -f frontend";
    };
    script = ''
      docker network inspect frontend || docker network create frontend
    '';
    partOf = [ "docker-compose-zabbix-web-root.target" ];
    wantedBy = [ "docker-compose-zabbix-web-root.target" ];
  };
  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-zabbix-web-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
