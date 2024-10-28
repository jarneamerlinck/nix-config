{ pkgs, config, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  username = "eragon";
in
{
  users.mutableUsers = true; # Only enable if you set password from sops or from nix-config
  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    uid=1442;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "mounts"
    ] ++ ifTheyExist [
      "network"
      "i2c"
      "docker"
      "git"
      "libvirtd"
      "deluge"
    ];

    openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/${username}/ssh.pub) ];
    hashedPasswordFile = config.sops.secrets."users/${username}".path;
    packages = [ pkgs.home-manager ];
  };

 sops.secrets."users/${username}" = {
   sopsFile = ../../secrets.yml;
   neededForUsers = true;
 };

  home-manager.users."${username}" = import ../../../../home/${username}/${config.networking.hostName}.nix;

  # services.geoclue2.enable = true;
  # security.pam.services = { swaylock = { }; };
}
