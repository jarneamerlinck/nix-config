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
  #   {
  #     device = "/var/lib/swapfile";
  #     size = 10240;
  #   }
  # ];
  boot.resumeDevice = "/dev/vda3";
  powerManagement.enable = true;
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";
}
