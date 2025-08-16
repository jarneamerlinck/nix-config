{ config, pkgs, ... }:
{

  sops.secrets."nix_cache/cache-priv-key.pem" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/run/secrets-for-users/nix_cache/cache-priv-key.pem";
  };
  virtualisation.oci-containers.containers."traefik" = {
    cmd = config.virtualisation.oci-containers.containers."traefik".cmd ++ [
      "--providers.file.filename=/etc/traefik/nix-cache.yml"
      "--providers.file.watch=true"
    ];
  };
}
