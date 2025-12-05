{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    hardware.bluetooth = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable bluetooth";
          };

        };
      };
    };

    hardware.hibernation = lib.mkOption {
      type = lib.types.submodule {
        options = {

          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable hibernation";
          };
        };
      };
    };
    hardware.battery = lib.mkOption {
      type = lib.types.submodule {
        options = {

          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable battery settings";
          };
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.hardware.bluetooth.enable {

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            # Shows battery charge of connected devices on supported
            # Bluetooth adapters. Defaults to 'false'.
            Experimental = true;
            # When enabled other devices can connect faster to us, however
            # the tradeoff is increased power consumption. Defaults to
            # 'false'.
            FastConnectable = true;
          };
          Policy = {
            # Enable all controllers when they are found. This includes
            # adapters present on start as well as adapters that are plugged
            # in later on. Defaults to 'true'.
            AutoEnable = true;
          };
        };
      };
      services.blueman.enable = true;
      environment.systemPackages = with pkgs; [ bluetui ];

    })

    (lib.mkIf config.hardware.hibernation.enable {

      services.logind.settings.Login = {
        HandleLidSwitch = if config.powerManagement.enable then "hibernate" else "suspend";
      };
      boot.resumeDevice = "${config.disko.devices.disk.boot_disk.device}3";
      boot.kernelParams = [ "resume_offset=0" ]; # This is because it's a sepperate partition
      powerManagement.enable = true;
      systemd.sleep.extraConfig = "HibernateDelaySec=1h";
    })

    (lib.mkIf config.hardware.battery.enable {
      services.auto-cpufreq = {
        enable = true;
      };

      services.logind.settings.Login = {
        HandleLidSwitchExternalPower = "sleep";
        HandleLidSwitchDocked = "ignore";
      };
      powerManagement.enable = true;
      systemd.sleep.extraConfig = "HibernateDelaySec=1h";

    })
  ];
}
