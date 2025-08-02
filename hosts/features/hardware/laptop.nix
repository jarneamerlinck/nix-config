{ pkgs, lib, ... }:
{
  services.auto-cpufreq = {
    enable = true;

  };
}
