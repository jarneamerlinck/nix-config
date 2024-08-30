{ lib, ... }:
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

      # Data disks for Btrfs RAID
      raid_d1 = {
        type = "disk";
        device = lib.mkDefault "/dev/sdc";
        content = {
          type = "gpt";
          partitions = {
            btrfs_data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
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
            btrfs_data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
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
            btrfs_data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
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
            btrfs_data = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
              };
            };
          };
        };
      };
    };
  };

  # Additional commands to configure Btrfs RAID
  systemd.services.setup-btrfs-raid = {
    wantedBy = [ "multi-user.target" ];
    script = ''
      btrfs device add ${btrfs_devices} /data
      btrfs balance start -dconvert=raid10 -mconvert=raid10 /data
    '';
    serviceConfig.ExecStartPre = [ "${pkgs.util-linux}/bin/mkdir -p /data" ];
    serviceConfig.ExecStartPost = [ "${pkgs.btrfs-progs}/bin/btrfs filesystem sync /data" ];
    serviceConfig.Restart = "on-failure";
  };
}
