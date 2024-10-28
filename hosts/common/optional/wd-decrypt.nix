{ pkgs, config, ... }:
let
  sops_decrypt_key = "wd-decrypt";
  sops_device_key = "wd-device-id";
  sops_device_partition = "wd-device-decrypted";
in
{

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

  environment.systemPackages = with pkgs; [
    sg3_utils
  ];
  environment.interactiveShellInit = ''
  alias wd_attach='sudo sg_raw -s 40 -i /run/secrets-for-users/${sops_decrypt_key} /dev/disk/by-id/$(sudo cat ${config.sops.secrets."${sops_device_key}".path}) c1 e1 00 00 00 00 00 00 28 00 && sleep 2 && sudo mount /dev/disk/by-id/$(sudo cat ${config.sops.secrets."${sops_device_partition}".path}) /mnt/wd && ${pkgs.coreutils}/bin/chgpr -R users /mnt/wd && ${pkgs.coreutils}/bin/chmod -R 770 /mnt/wd'
'';
}
