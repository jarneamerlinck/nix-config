{ pkgs, lib, config, inputs, ... }:
{
  services.zabbixServer = {
    enable= true;
    openFirewall = true;

  };
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.zabbixWeb = {
    enable = true;
    virtualHost = {
      hostName = "zabbix.localhost";
      adminAddr = "webmaster@localhost";
      networking = {
        networkConfig = {
          # Add the Zabbix web to the frontend Docker network
          docker.networks.frontend.connect = [ config.services.zabbixWeb ];
        };
      };
    };
  };

}
