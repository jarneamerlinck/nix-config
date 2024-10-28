{ pkgs, config, ... }:
{
  systemd.services.ensureMntDir = {
    description = "Ensure /mnt directory exists";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.coreutils}/bin/mkdir -p /mnt";
      ExecStartPost = "${pkgs.coreutils}/bin/chmod 0755 /mnt"; # Set permissions
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };}
