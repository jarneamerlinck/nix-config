{   config, pkgs,  ...}:
let

in
  {
  networking.firewall.allowedUDPPorts = [ 51820 ];
  services.netbird.enable = true;
  environment.systemPackages = with pkgs; [
    netbird
  ];
  sops.secrets."netbird_server_url" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yaml;
    neededForUsers = true;
  };
  sops.secrets."netbird_api_key" = {
    sopsFile = ../../${config.networking.hostName}/secrets.yaml;
    neededForUsers = true;
  };
  # Netbird configuration
  systemd.services.netbird = {
    description = "Netbird VPN Service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.netbird}/bin/netbird service";
      Restart = "always";
      RestartSec = "5s";
      User = "root";
    };

    # Automatically configure Netbird with the API key
    # Replace `<YOUR_API_KEY>` with your actual Netbird API key.
    preStart = ''
      if ! [ -f /etc/netbird/config.json ]; then
        ${pkgs.netbird}/bin/netbird up --management-url $(sudo cat ${config.sops.secrets."netbird_server_url".path}) --api-key $(sudo cat ${config.sops.secrets."netbird_api_key".path})
      fi
    '';

    wantedBy = [ "multi-user.target" ];
  };
}
