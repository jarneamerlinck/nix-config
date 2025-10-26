# Auto-generated using compose2nix v0.2.3-pre.
{ pkgs, lib, config, ... }:
let
  sops_settings = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };
  keys = [ "zone" "fqdn" "email" "token" ];

in {

  sops.secrets = builtins.listToAttrs ((map (item_key: {
    name = "ddns/${item_key}";
    value = sops_settings;
  }) keys));

  services.ddclient = {
    enable = true;
    use = "web";
    server = "api.cloudflare.com/client/v4";
    protocol = "cloudflare";
    passwordFile = config.sops.secrets."ddns/token".path;
    username = config.sops.secrets."ddns/email".path;
    zone = "knightofzero.com";
    domains = [ "vps.knightofzero.com" ];
    # extraConfig = {
    #   web = "dynamicdns.park-your-domain.com/getip";
    # };
  };
}
