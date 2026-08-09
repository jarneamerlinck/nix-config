{ pkgs, config, ... }:
{

  sops.secrets."newt/env" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
  };

  services.newt = {
    enable = true;
    environmentFile = config.sops.secrets."newt/env".path;
  };
}
