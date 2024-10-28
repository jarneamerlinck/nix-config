{ pkgs, config, ... }:
let
  sops_decrypt_key = "wd-decrypt";
  sops_device_key = "wd-device-id";
  sops_device_partition = "wd-device-decrypted";
in
{

  environment.systemPackages = with pkgs; [
    sg3_utils
  ];
  services.udisks2 = {
    enable = true;

  };

  sops.secrets."${sops_decrypt_key}" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."${sops_device_key}" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };

  sops.secrets."${sops_device_partition}" = {
    sopsFile = ../users/eragon/secrets.yml;
    neededForUsers = true;
  };



  environment.interactiveShellInit = ''
  alias wd_decrypt='sudo sg_raw -s 40 -i /run/secrets-for-users/${sops_decrypt_key} /dev/disk/by-id/$(sudo cat ${config.sops.secrets."${sops_device_key}".path}) c1 e1 00 00 00 00 00 00 28 00'
  alias wd_mount='sudo mount -t ext4 -o umask=770,gid=100 /dev/disk/by-id/$(sudo cat ${config.sops.secrets."${sops_device_partition}".path}) /mnt/wd'
  alias wd_attach='wd_decrypt && sleep 3 && wd_mount'
'';
}
