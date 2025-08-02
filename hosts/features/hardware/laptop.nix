{ pkgs, lib, ... }:
{
  services.auto-cpufreq = {
    enable = true;
  };
  service.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "sleep";
    lidSwitchDocked = "ignore";
  };
}
