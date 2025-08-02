{ pkgs, lib, ... }:
{
  services.auto-cpufreq = {
    enable = true;
  };
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "sleep";
    lidSwitchDocked = "ignore";
  };
}
