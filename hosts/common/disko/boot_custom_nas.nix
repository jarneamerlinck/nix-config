{ lib, ... }:
{
  disko.devices = {
    disk = {
      boot_disk = {
        device = lib.mkDefault "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            esp = {
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
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
                  };
                  "/nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                };
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
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                };
              };
            };
          };
        };
      };

      # RAID 10
      raid_d1 = {
        device = lib.mkDefault "/dev/sdc";
        type = "disk";
        content = {
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid10";
            };
          };
        };
      };

      raid_d2 = {
        device = lib.mkDefault "/dev/sdd";
        type = "disk";
        content = {
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid10";
            };
          };
        };
      };

      raid_d3 = {
        device = lib.mkDefault "/dev/sde";
        type = "disk";
        content = {
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid10";
            };
          };
        };
      };

      raid_d4 = {
        device = lib.mkDefault "/dev/sdf";
        type = "disk";
        content = {
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid10";
            };
          };
        };
      };

      raid_d5 = {
        device = lib.mkDefault "/dev/sdg";
        type = "disk";
        content = {
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid10";
            };
          };
        };
      };

      raid_d6 = {
        device = lib.mkDefault "/dev/sdh";
        type = "disk";
        content = {
          mdadm = {
            size = "100%";
            content = {
              type = "mdraid";
              name = "raid10";
            };
          };
        };
      };


    # END RAID 10
    };
    mdadm = {
      # boot = {
      #   type = "mdadm";
      #   level = 1;
      #   metadata = "1.0";
      #   content = {
      #     type = "filesystem";
      #     format = "vfat";
      #     mountpoint = "/data";
      #   };
      # };
      raid10 = {
        type = "mdadm";
        level = 1;
        content = {
          type = "gpt";
          partitions.primary = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/data";
            };
          };
        };
      };
    };

  };
}
