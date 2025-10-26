{ pkgs, lib, config, inputs, ... }:
let
  publicKeyHome = "WkVNNITeeTyUnTLrjfDYwNI4rqpquZ5rkWlffvQwJmI=";
  publicKeyHomeSafe = "WkVNNITeeTyUnTLrjfDYwNI4rqpquZ5rkWlffvQwJmI";
in {
  sops.secrets."wireguard/privateKey" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."wireguard/presharedKey" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."wireguard/endpoint" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  networking.firewall = {
    allowedUDPPorts =
      [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  networking.wireguard = {
    enable = true;
    interfaces = {

      wg0 = {
        ips = [ "10.5.5.7/32" ];
        listenPort = 51820;

        privateKeyFile = config.sops.secrets."wireguard/privateKey".path;

        peers = [{
          publicKey = "${publicKeyHome}";
          presharedKeyFile = config.sops.secrets."wireguard/presharedKey".path;
          allowedIPs = [ "10.20.0.0/24" ];
          persistentKeepalive = 25;
        }];
      };
    };
  };
  systemd.services.wg-set-endpoint = {
    description = "Set WireGuard Peer Endpoint";
    wants = [ "wireguard-wg0-peer-${publicKeyHomeSafe}\\x3d.service" ];
    after = [ "wireguard-wg0-peer-${publicKeyHomeSafe}\\x3d.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.wireguard-tools}/bin/wg set wg0 peer ${publicKeyHome} endpoint "$$(tr -d '\n' <  ${
          config.sops.secrets."wireguard/endpoint".path
        })"
      '';
    };
  };

}
