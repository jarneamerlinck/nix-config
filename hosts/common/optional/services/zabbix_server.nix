{ pkgs, lib, config, inputs, ... }:
{
  services.zabbixServer = {
    enable = true;
    openFirewall = true;
  };

  services.nginx = {
    enable = true;
    virtualHosts = [
      {
        serverName = "zabbix.local";
        listen = [ { addr = "0.0.0.0"; port = 31443; } ];
        root = "${pkgs.zabbix.web}/share/zabbix/";
        extraConfig = ''
          location / {
            try_files $uri $uri/ =404;
          }
        '';
      }
    ];

    # # Ensure no default server listens on port 80
    # defaultServer = {
    #   listen = [ { addr = "0.0.0.0"; port = 80; } ];
    #   extraConfig = ''
    #     return 404;
    #   '';
    # };
  };

  networking.firewall.allowedTCPPorts = [ 31443 ];
}
