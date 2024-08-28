{ lib, config, ... }:
let
  btrfs_devices = "${config.disko.devices.disk.raid_d1.device}1 ${config.disko.devices.disk.raid_d2.device}1 ${config.disko.devices.disk.raid_d3.device}1 ${config.disko.devices.disk.raid_d4.device}1";
in
{
  disko.devices = {
    disk = {
      # Boot disk 1
      boot = {
        type = "disk";
        device = lib.mkDefault "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
            };
          };
        };
      };

      raid_d1 = {
        type = "disk";
        device = lib.mkDefault "/dev/sdc";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                extraArgs = [ "-f" ];
                type = "btrfs";
              };
            };
          };
        };
      };

      raid_d2 = {
        type = "disk";
        device = lib.mkDefault "/dev/sdd";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                extraArgs = [ "-f" ];
                type = "btrfs";
              };
            };
          };
        };
      };

      raid_d3 = {
        type = "disk";
        device = lib.mkDefault "/dev/sde";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                extraArgs = [ "-f" ];
                type = "btrfs";
              };
            };
          };
        };
      };

      raid_d4 = {
        type = "disk";
        device = lib.mkDefault "/dev/sdf";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                extraArgs = [ "-f" ];
                type = "btrfs";
              };
            };
          };
        };
      };
    };
  };

  # To be mounted after the system boots
  # To be mounted after the system boots
  fileSystems."/data" = {
    device = btrfs_devices;
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "nofail" ];
  };

}
