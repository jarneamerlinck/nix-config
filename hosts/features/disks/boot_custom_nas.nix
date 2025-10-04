{
  lib,
  config,
  pkgs,
  ...
}:
# https://github.com/tiredofit/nixos-config/blob/da4b765d8d496e821828d173705fcef010dae10f/deploy-templates/disko/efi-btrfs-swap-raid1.nix
# https://github.com/nix-community/disko/issues/543
#https://github.com/elliottminns/dotfiles/blob/2985327b3fbd1d127df9cf0acb1e7b09a88b44ba/nix/machines/amaterasu/disko-config-raid.nix#L3
#https://github.com/tiredofit/nixos-config/blob/dc03fb4a210e4e3f033952391b4049b1f1d23811/deploy-templates/disko/efi-btrfs-swap-raid1.nix#L6
#https://github.com/josephst/nixfiles/blob/48cd155c9779f535836e74ef54ad3bf55c753557/hosts/nixos/terminus/disko-hdd-storage.nix#L4
#https://github.com/kaldyr/nixos/blob/8c8aa3ccbb7d64e9b2559eee3329f981ce871e60/systems/magrathea.nix#L84
#https://github.com/budimanjojo/nix-config/blob/4d77edbe58a499c151352d592f1a561176ddef22/system/hosts/budimanjojo-nas/disk-config.nix#L64
#https://github.com/tiredofit/nixos-config/blob/dc03fb4a210e4e3f033952391b4049b1f1d23811/deploy-templates/disko/efi-luks-btrfs-impermanence-swap-raid1.nix#L7

{

  imports = [
    ./btrfs.nix
  ];
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
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  "/rootfs" = {
                    mountpoint = "/";
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

      nvme_home = {
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
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/home";
                  };
                  ".snapshots" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/home/.snapshots";
                  };
                };
              };
            };
          };
        };
      };
      nvme_var = {
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
                  "/var" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/var";
                  };
                  ".snapshots" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/var/.snapshots";
                  };
                };
              };
            };
          };
        };
      };
      # Data disks for Btrfs RAID
      data = {
        type = "disk";
        device = lib.mkDefault "/dev/sdc";
        content = {
          type = "gpt";
          partitions = {
            btrfs_data = {
              size = "100%";
              label = "data";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                subvolumes = {
                  ".snapshots" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "nofail"
                    ];
                    mountpoint = "/data/.snapshots";
                  };
                  "/data" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "nofail"
                    ];
                    mountpoint = "/data";
                  };
                  "/backup" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "nofail"
                    ];
                    mountpoint = "/data/backup";
                  };
                  "/sync" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "nofail"
                    ];
                    mountpoint = "/data/sync";
                  };
                  "/ml" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                      "nofail"
                    ];
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
