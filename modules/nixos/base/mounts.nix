{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {

    base.mounts = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable the mount points module";
          };

          wd = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable mount point for wd";
          };
        };
      };

      default = { };
    };
  };

  config = lib.mkIf config.base.mounts.enable {

    systemd.services = {
      ensureMntDir = {
        description = "Ensure /mnt directory exists";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.coreutils}/bin/mkdir -p /mnt";
          ExecStartPost = "${pkgs.coreutils}/bin/chmod 0755 /mnt";
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
      ensureWDMntDir = lib.mkIf config.base.mounts.wd {
        description = "Ensure /mnt/wd directory exists";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${pkgs.coreutils}/bin/mkdir -p /mnt/wd";
          ExecStartPost = "${pkgs.coreutils}/bin/chmod 0755 /mnt/wd";
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    };
  };
}
