{ pkgs, config, inputs, outputs, ... }:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  username = "eragon";
  lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
  systems = [ "x86_64-linux" "aarch64-linux" ];
  pkgsFor = lib.genAttrs systems (system: import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  });

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
      "libvirt-qemu"
      "deluge"
      "wireshark"
    ];

    openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/${username}/ssh.pub) ];
    hashedPasswordFile = config.sops.secrets."users/${username}".path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets."users/${username}" = {
    sopsFile = ../../secrets.yml;
    neededForUsers = true;
  };

  lib.homeConfigurations."${username}@${config.networking.hostName}" = lib.homeManagerConfiguration {
    modules = [ ../../../../home/${username}/${config.networking.hostName}.nix ];
    pkgs = pkgsFor."${config.nixpkgs.hostPlatform.system}";
    extraSpecialArgs = { inherit inputs outputs; };
  };


  home-manager.users."${username}" = import ../../../../home/${username}/${config.networking.hostName}.nix;

  # services.geoclue2.enable = true;
  # security.pam.services = { swaylock = { }; };
}
