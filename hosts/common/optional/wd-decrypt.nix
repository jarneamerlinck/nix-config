{ pkgs, config, ... }:
{

 sops.secrets."wd-decrypt" = {
   sopsFile = ../users/eragon/secrets.yml;
   neededForUsers = true;
 };

  environment.systemPackages = with pkgs; [
    sg3_utils
  ];
}
