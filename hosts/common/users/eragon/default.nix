{ pkgs, config, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false; # Only enable if you set password from sops or from nix-config
  users.users.eragon = {
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

    openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/eragon/ssh.pub) ];
    # initialPassword = ""; # TODO change password after first boot
    packages = [ pkgs.home-manager ];
  };

 # sops.secrets.eragon-password = {
 #   sopsFile = ../../secrets.yaml;
 #   neededForUsers = true;
 # };

  home-manager.users.eragon = import ../../../../home/eragon/${config.networking.hostName}.nix;

  # services.geoclue2.enable = true;
  # security.pam.services = { swaylock = { }; };
}
