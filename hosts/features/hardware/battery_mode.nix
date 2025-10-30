{ ... }: {
  services.auto-cpufreq = { enable = true; };

  services.logind = {
    lidSwitchExternalPower = "sleep";
    lidSwitchDocked = "ignore";
  };
  powerManagement.enable = true;
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";
}
