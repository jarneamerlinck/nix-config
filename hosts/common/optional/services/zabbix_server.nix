{ pkgs, lib, config, inputs, ... }:
{
  services.zabbixServer = {
    enable= true;
    openFirewall = true;

  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.zabbixWeb = {
    enable = true;
    virtualHost = {
      hostName = "zabbix.localhost";
      adminAddr = "webmaster@localhost";
    };
  };

}
