{ pkgs, lib, config, inputs, ... }:
{
  services.zabbixServer = {
    enable= true;
    openFirewall = true;

  };
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.zabbixWeb = {
    enable = true;
    frontend = "httpd";
    virtualHost = {
      hostName = "zabbix.localhost";
      adminAddr = "webmaster@localhost";
      listen."default".port = "10049";
    };
  };

}
