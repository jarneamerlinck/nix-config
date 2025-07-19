{ pkgs, lib, config, inputs, ... }:
{
  services.zabbixAgent = {
    enable = true;
    server = "localhost";
  };
}
