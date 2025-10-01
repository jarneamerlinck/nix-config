{ pkgs, ... }:
{
  systemd.services.ensureMntDir = {
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

  systemd.services.ensureWDMntDir = {
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
}
