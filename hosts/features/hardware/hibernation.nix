{ config, lib, ... }:
let
  disk = config.disko.devices.disk.boot_disk.device;
in
{
  services.logind.settings.Login = {
    HandleLidSwitch = if config.powerManagement.enable then "hibernate" else "suspend";
  };
  boot.resumeDevice = if lib.hasPrefix "/dev/disk/by-" disk then "${disk}-part3" else "${disk}3";
  boot.kernelParams = [ "resume_offset=0" ]; # This is because it's a sepperate partition
  powerManagement.enable = true;
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "1h";
  };
}
