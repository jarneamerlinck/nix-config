{
  pkgs,
  lib,
  outputs,
  ...
}:
{
  services.auto-cpufreq = {
    enable = true;
  };
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "sleep";
    lidSwitchDocked = "ignore";
  };
  # swapDevices = [
  #   { device = outputs.disko.devices.disk.boot_disk.device; }
  # ];
  boot.resumeDevice = "/dev/vda3";

}
