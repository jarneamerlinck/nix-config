{
  config,
  pkgs,
  lib,
  ...
}:
{

  sops.secrets."nix_cache/cache-priv-key.pem" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."nix_cache/nix-cache.yml" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/run/secrets-for-users/nix_cache/cache-priv-key.pem";
  };
  virtualisation.oci-containers.containers."traefik" = {

    volumes = lib.mkForce [
      "/data/docker/traefik/letsencrypt:/letsencrypt:rw"
      "/var/run/docker.sock:/var/run/docker.sock:ro"
      "/run/secrets-for-users/nix_cache/nix-cache.yml:/etc/traefik/nix-cache.yml:ro"
    ];
    cmd = lib.mkForce [
      "--accesslog=true"
      "--accesslog.filePath=/logs/access.log"
      "--api.insecure=true"
      "--providers.docker=true"
      "--providers.docker.exposedbydefault=false"

      "--entryPoints.http.address=:80"
      "--entrypoints.web.http.redirections.entrypoint.to=https"
      "--entryPoints.web.http.redirections.entrypoint.scheme=https"

      "--entryPoints.https.address=:443"
      "--certificatesresolvers.cloudflare.acme.dnschallenge=true"
      "--certificatesresolvers.cloudflare.acme.dnschallenge.provider=cloudflare"
      "--certificatesresolvers.cloudflare.acme.email=jarneamerlinck@pm.me"
      "--certificatesresolvers.cloudflare.acme.storage=/letsencrypt/acme.json"

      "--providers.file.filename=/etc/traefik/nix-cache.yml"
      "--providers.file.watch=true"
    ];
  };
}
