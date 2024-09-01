{ lib,config,pkgs, ... }:
let

  # btrfs_devices = "${config.disko.devices.disk.raid_d1.device}1 ${config.disko.devices.disk.raid_d2.device}1 ${config.disko.devices.disk.raid_d3.device}1 ${config.disko.devices.disk.raid_d4.device}1";
  # btrfs_devices = " ${config.disko.devices.disk.raid_d2.device} ${config.disko.devices.disk.raid_d3.device} ${config.disko.devices.disk.raid_d4.device}";
  btrfs_first_disk = "/dev/sdb";
  btrfs_devices = "/dev/sdc /dev/sdd /dev/sde";
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

      nvme1 = {
        device = lib.mkDefault "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  "/home" = {
                    mountOptions = [ "compress=zstd" "noatime"];
                    mountpoint = "/home";
                  };
                };
              };
            };
          };
        };
      };
      # Data disks for Btrfs RAID
     data  = {
        type = "disk";
        device = lib.mkDefault "${btrfs_first_disk}";
        content = {
          type = "gpt";
          partitions = {
            btrfs_data = {
              size = "100%";
              label= "data";
              content = {
                type = "btrfs";
                mountpoint = "/data";
                mountOptions = [ "compress=zstd" "noatime" "nofail" ];
                # extraArgs = [ "-f" "-m raid10 -d raid10" "${btrfs_devices}" ];
              };
            };
          };
        };
      };
    };
  };
}
