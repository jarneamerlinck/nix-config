{ pkgs, lib, config, inputs, ... }:
{

  sops.secrets."wireguard" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yml;
    neededForUsers = true;
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };
  networking.wireguard = {
    enable = true;
    interfaces = {

      wg0 = {
        # Determines the IP address and subnet of the client's end of the tunnel interface.
        ips = [ "10.5.5.2/32" ];
        listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

        # Path to the private key file.
        #
        # Note: The private key can also be included inline via the privateKey option,
        # but this makes the private key world-readable; thus, using privateKeyFile is
        # recommended.
        privateKeyFile = "path to private key file";

        peers = [
          {
            publicKey = "WkVNNITeeTyUnTLrjfDYwNI4rqpquZ5rkWlffvQwJmI=";

            allowedIPs = [ "10.20.0.0/24" ];

            persistentKeepalive = 25;
          }
        ];
      };
    };



  };
  # systemd.services."wg-quick-wg0".serviceConfig = {
  #   ExecStartPre = [
  #     # Use sed to inject the endpoint into the generated config file
  #     ''
  #       ${pkgs.sed}/bin/sed -i "/^Endpoint =/c\Endpoint = $(cat ${config.sops.secrets."wireguard/endpoint".path})" /etc/wireguard/wg0.conf
  #     ''
  #   ];
  # };

}
