
# Auto-generated using compose2nix v0.2.3-pre.
{ pkgs, lib, ... }:

{
  # Runtime
  # Containers
  virtualisation.oci-containers.containers."freshrss" = {
    image = "lscr.io/linuxserver/freshrss:1.24.3-ls244
";
    environment = {
      "PGID" = "100";
      "PUID" = "1442";
      "TZ" = "Europe/London";
    };
    volumes = [
      "/data/docker/freshrss:/config:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cpu-quota=0.2"
      "--cpus=0.01"
      "--health-cmd=curl --fail http://localhost:80 || exit 1"
      "--health-interval=1m0s"
      "--health-retries=5"
      "--health-start-period=20s"
      "--health-timeout=10s"
      "--memory-reservation=83886080b"
      "--memory=314572800b"
      "--network-alias=freshrss"
      "--network=frontend"
      "--network=rss"
    ];
  };
  systemd.services."docker-freshrss" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    partOf = [
      "docker-compose-rss-root.target"
    ];
    wantedBy = [
      "docker-compose-rss-root.target"
    ];
  };
  virtualisation.oci-containers.containers."full-test-rss" = {
    image = "heussd/fivefilters-full-text-rss:3.8.1";
    ports = [
      "50000:80/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--cpu-quota=0.05"
      "--cpus=0.01"
      "--health-cmd=curl --fail http://localhost:80 || exit 1"
      "--health-interval=1m0s"
      "--health-retries=5"
      "--health-start-period=20s"
      "--health-timeout=10s"
      "--memory-reservation=83886080b"
      "--memory=314572800b"
      "--network-alias=full-test-rss"
      "--network=frontend"
      "--network=rss"
    ];
  };
  systemd.services."docker-full-test-rss" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
      RestartMaxDelaySec = lib.mkOverride 500 "1m";
      RestartSec = lib.mkOverride 500 "100ms";
      RestartSteps = lib.mkOverride 500 9;
    };
    partOf = [
      "docker-compose-rss-root.target"
    ];
    wantedBy = [
      "docker-compose-rss-root.target"
    ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-rss-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
