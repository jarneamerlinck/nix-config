{
  pkgs,
  config,
  ...
}:
let
  publicKeyHome = "WkVNNITeeTyUnTLrjfDYwNI4rqpquZ5rkWlffvQwJmI=";
  publicKeyHomeSafe = "WkVNNITeeTyUnTLrjfDYwNI4rqpquZ5rkWlffvQwJmI";
in
{
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
  sops.secrets."wireguard/allowedIps" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  # you can disable this with `sudo systemctl stop wireguard-wg0.service`
  networking.wireguard = {
    enable = true;
    interfaces = {

      wg0 = {
        ips = [ "10.5.5.7/32" ];
        listenPort = 51820;

        privateKeyFile = config.sops.secrets."wireguard/privateKey".path;

        peers = [
          {
            publicKey = "${publicKeyHome}";
            presharedKeyFile = config.sops.secrets."wireguard/presharedKey".path;
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
  systemd.services.wg-set-endpoint = {
    description = "Set WireGuard Peer Endpoint";
    wants = [ "wireguard-wg0-peer-${publicKeyHomeSafe}\\x3d.service" ];
    after = [ "wireguard-wg0-peer-${publicKeyHomeSafe}\\x3d.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = ''
        ip route del 10.20.0.0/24 dev wg0 || true
      '';
    };
    script = ''
      ${pkgs.wireguard-tools}/bin/wg set wg0 peer ${publicKeyHome} \
        endpoint "$(cat /run/secrets-for-users/wireguard/endpoint)"

      ${pkgs.wireguard-tools}/bin/wg set wg0 peer ${publicKeyHome} \
        allowed-ips "$(cat /run/secrets-for-users/wireguard/allowedIps)"

      ${pkgs.iproute2}/bin/ip route add 10.20.0.0/24 dev wg0
    '';
  };

}
