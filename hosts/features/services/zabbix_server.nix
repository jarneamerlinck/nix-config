{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  services.zabbixServer = {
    enable = true;
    openFirewall = true;
  };
}
