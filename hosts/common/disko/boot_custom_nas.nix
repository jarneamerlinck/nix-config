{ lib,config,pkgs, ... }:
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
        device = lib.mkDefault "/dev/sdc";
        content = {
          type = "gpt";
          partitions = {
            btrfs_data = {
              size = "100%";
              label= "data";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  ".snapshots" = {
                    mountOptions = [ "compress=zstd" "noatime" "nofail" ];
                    mountpoint = "/.snapshots";
                  };
                  "/data" = {
                    mountOptions = [ "compress=zstd" "noatime" "nofail" ];
                    mountpoint = "/data";
                  };
                  "/backup" = {
                    mountOptions = [ "compress=zstd" "noatime" "nofail" ];
                    mountpoint = "/data/backup";
                  };
                  "/sync" = {
                    mountOptions = [ "compress=zstd" "noatime" "nofail" ];
                    mountpoint = "/data/sync";
                  };
                  "/ml" = {
                    mountOptions = [ "compress=zstd" "noatime" "nofail" ];
                    mountpoint = "/data/ml";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
