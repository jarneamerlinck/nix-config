# Example to create a bios compatible gpt partition
{ lib, ... }:
{

  imports = [
    ./btrfs.nix
    ./clevis.nix
  ];

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
            swap = {
              name = "swap";
              size = "10240M";
              type = "8200";
              content = {
                type = "swap";
              };
            };
            lusk = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # disable settings.keyFile if you want to use interactive password entry
                passwordFile = "/tmp/disk.key"; # Interactive
                # settings = {
                #   allowDiscards = true;
                #   keyFile = "/tmp/disk-1.key";
                # };
                content = {
                  type = "btrfs";
                  extraArgs = [ ];
                  subvolumes = {
                    "/rootfs" = {
                      mountpoint = "/";
                    };

                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    ".snapshots" = {
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                      mountpoint = "/.snapshots";
                    };
                    "/nix" = {
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
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
  };
}
