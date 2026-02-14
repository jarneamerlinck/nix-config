# Auto-generated using compose2nix v0.2.3-pre.

{

  services.zabbixServer.enable = true;
  services.zabbixWeb = {
    enable = true;
    virtualHost = {
      hostName = "zabbix.k0z.net"; # doesn't work
      adminAddr = "webmaster@localhost";
    };
  };

}
