{ lib,config,pkgs, ... }:
# let
#   btrfs_first_disk = "/dev/sdb";
#   btrfs_devices = "/dev/sdc /dev/sdd /dev/sde";
# in
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
        # device = lib.mkDefault "${btrfs_first_disk}";
        device = lib.mkDefault "/dev/sdc";
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
              };
            };
          };
        };
      };
    };
  };
}
