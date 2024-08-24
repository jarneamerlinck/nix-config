{ lib, ... }:
{
  disko.devices = {
    disk = {
      # Boot disk 1
      boot_one = {
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
              size = "500M";
              type = "EF00";
              content = {
                type = "mdraid";
                name = "boot";
              };
            };
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid_boot";
              };
            };
          };
        };
      };

      boot_two = {
        type = "disk";
        device = lib.mkDefault "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "mdraid";
                name = "boot";
              };
            };
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid_boot";
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
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };
      raid_boot = {
        type = "mdadm";
        level = 1;
        content = {
          type = "gpt";
          partitions.primary = {
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
      raid_data = {
        type = "mdadm";
        level = 10;
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          mountpoint = "/home";
          mountOptions = [ "compress=zstd"  ];
        };
      };
    };
  };
}
