{ config, ... }: {
  services.logind = {
    lidSwitch =
      if config.powerManagement.enable then "hibernate" else "suspend";
  };
  boot.resumeDevice = "${config.disko.devices.disk.boot_disk.device}3";
  boot.kernelParams =
    [ "resume_offset=0" ]; # This is because it's a sepperate partition
  powerManagement.enable = true;
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";
}
