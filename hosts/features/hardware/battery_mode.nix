{ ... }: {
  services.auto-cpufreq = { enable = true; };

  services.logind.settings.Login = {
    HandleLidSwitchExternalPower = "sleep";
    HandleLidSwitchDocked = "ignore";
  };
  powerManagement.enable = true;
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";
}
