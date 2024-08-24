{ lib, ... }:
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
      raid_d1 = {
        type = "disk";
        device = lib.mkDefault "/dev/sdc";
        content = {
          type = "gpt";
          partitions = {
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid_data";
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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid_data";
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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid_data";
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
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid_data";
              };
            };
          };
        };
      };

      raid_d5 = {
        type = "disk";
        device = lib.mkDefault "/dev/sdg";
        content = {
          type = "gpt";
          partitions = {
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid_data";
              };
            };
          };
        };
      };

      raid_d6 = {
        type = "disk";
        device = lib.mkDefault "/dev/sdh";
        content = {
          type = "gpt";
          partitions = {
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid_data";
              };
            };
          };
        };
      };


    };

    # RAID configurations
    mdadm = {
      raid_data = {
        type = "mdadm";
        level = 10;
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          mountpoint = "/data";
          mountOptions = [ "compress=zstd" "noatime" "nofail" ];
        };
      };
    };
  };
}
