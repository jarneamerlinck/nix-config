# Example to create a bios compatible gpt partition
{ lib, ... }: {

  imports = [ ./btrfs.nix ];

  disko.devices = {
    disk = {
      boot = {
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
                  "/rootfs" = { mountpoint = "/"; };
                  ".snapshots" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/.snapshots";
                  };
                };
              };
            };
          };
        };
      };

      data = {
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
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/home";
                  };
                  ".snapshots" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/home/.snapshots";
                  };

                  "/var" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/var";
                  };

                  "/data" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/data";
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
    };
  };
}
