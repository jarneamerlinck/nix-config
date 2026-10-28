{ config, ... }:
{

  sops.secrets."runner/auth_token" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
  };
  sops.secrets."runner/uuid" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
  };
  services.forgejo-runner.instances."${config.networking.hostName}" = {
    enable = true;
    runtimes = {
      host = true;
      docker = false;
      podman = false;
    };
    secrets = {
      server.connections.default = {
        token = config.sops.secrets."runner/auth_token".path;
        uuid = config.sops.secrets."runner/uuid".path;
      };
    };
    settings = {
      server.connections.default = {
        url = "https://git.ko0.net";
      };
    };
  };
}
