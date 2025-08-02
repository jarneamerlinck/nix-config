{ pkgs, lib, ... }:
{
  services.auto-cpufreq = {
    enable = true;
  };
  service.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "hybrid-sleep";
    lidSwitchDocked = "ignore";

  };
}
