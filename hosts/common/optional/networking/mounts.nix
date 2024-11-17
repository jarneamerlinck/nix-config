{ outputs, lib, pkgs,config,  ... }:
let
    uid_int = config.users.users.eragon.uid;
    uid_user = toString uid_int;
in
{
  environment.systemPackages = [ pkgs.cifs-utils ];
  fileSystems."/mnt/share" = {
    device = "//10.20.0.101/rpi";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

    in ["${automount_opts},credentials=/home/eragon/.smbcredentials,gid=1442"];
  };

}
