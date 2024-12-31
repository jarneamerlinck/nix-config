# Auto-generated using compose2nix v0.2.3-pre.
{ 
  pkgs,
  lib,
  config,
  ...
}: let
  sops_settings = {
    sopsFile = ../../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };
  keys = ["zone" "fqdn" "email" "token"];

in  {

  sops.secrets = builtins.listToAttrs (
    (map (item_key: {
      name = "ddns/${item_key}";
      value = sops_settings;
    }) keys));


  services.ddclient = {
    enable = true;
    config = {
      use = "web";
      web = "dynamicdns.park-your-domain.com/getip";
      protocol = "cloudflare";
      server = "api.cloudflare.com/client/v4";
      login = config.sops.secrets."ddns/email".path;
      password = config.sops.secrets."ddns/token".path;
      zone = config.sops.secrets."ddns/zone".path;
      fqdn = config.sops.secrets."ddns/fqdn".path;
    };
  };
}
