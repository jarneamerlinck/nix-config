{ pkgs, config, ... }:
let
  sops_decrypt_key = "wd-decrypt";
  sops_device_key = "wd-device-id";
  device_partition = "wwn-0x50014ee6094bb38a-part1";
in
{

  environment.systemPackages = with pkgs; [
    sg3_utils
  ];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  sops.secrets."${sops_decrypt_key}" = {
    sopsFile = ../../base/users/eragon/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."${sops_device_key}" = {
    sopsFile = ../../base/users/eragon/secrets.yml;
    neededForUsers = true;
  };

  fileSystems."/mnt/wd" = {
    device = "/dev/disk/by-id/${device_partition}";
    fsType = "ext4";
    options = [
      "noatime"
      "nofail"
      "noauto"
    ];
  };

  environment.interactiveShellInit = ''
    alias wd_decrypt='sudo sg_raw -s 40 -i /run/secrets-for-users/${sops_decrypt_key} /dev/disk/by-id/$(sudo cat ${
      config.sops.secrets."${sops_device_key}".path
    }) c1 e1 00 00 00 00 00 00 28 00'
    alias wd_mount='sudo mount /mnt/wd'
    alias wd_attach='wd_decrypt && sleep 3 && wd_mount'
  '';

}
