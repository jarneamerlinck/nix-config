{
  lib,
  config,
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  homeBasePath = ../../../home;
  host = config.networking.hostName;
  lib = inputs.nixpkgs.lib // inputs.home-manager.lib;
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
  pkgsFor = lib.genAttrs systems (
    system:
    import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    }
  );
  # Default users
  defaultUsers = {
    eragon = {
      shell = pkgs.zsh;
      groups = [
        "wheel"
        "video"
        "audio"
        "mounts"
      ]
      ++ ifTheyExist [
        "network"
        "i2c"
        "docker"
        "git"
        "libvirtd"
        "libvirt-qemu"
        "deluge"
        "wireshark"
      ];
      uid = 1442;
    };
  };
  users = builtins.attrNames defaultUsers;
  enabledUsers = lib.attrsets.filterAttrs (_: user: user.enable or false) defaultUsers;

  # Allow rebuild for home manager for a device
  homeConfs = builtins.listToAttrs (
    builtins.map (username: {
      name = "${username}@${host}";
      value = lib.homeManagerConfiguration {
        modules = [ ../../../../home/${username}/${host}.nix ];
        pkgs = pkgsFor.${config.nixpkgs.hostPlatform.system};
        extraSpecialArgs = { inherit inputs outputs; };
      };
    }) (builtins.attrNames enabledUsers)
  );
in
{

  options = {
    base.users = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Enable users module";
          };

          isMutableUsers = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Allow password changes outside of sops";
          };
          usersConfiguration = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  enable = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                  };
                  useHomeManager = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                  };
                  groups = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [
                      "video"
                      "audio"
                      "mounts"
                    ];
                  };
                  shell = lib.mkOption {
                    type = lib.types.path;
                    default = pkgs.bash;
                  };
                  uid = lib.mkOption {
                    type = lib.types.int;
                  };
                };
              }
            );
            default = defaultUsers;
          };

        };
      };

      default = { };
    };
  };

  config = lib.mkIf config.base.users.enable {
    users.mutableUsers = config.base.users.isMutableUsers;

    users.users = lib.mapAttrs (
      username: userAttrs:
      let
        homePath = "${homeBasePath}/${username}";
        entries = builtins.readDir homePath;
        subdirs = builtins.filter (
          name: entries.${name} == "directory" && name != config.networking.hostName && name != "features"
        ) (builtins.attrNames entries);

        sshKeys = builtins.filter (x: x != null) (
          builtins.map (
            dir:
            let
              keyPath = "${homePath}/${dir}/ssh.pub";
            in
            if builtins.pathExists keyPath then builtins.readFile keyPath else null
          ) subdirs
        );
      in
      {
        isNormalUser = lib.mkDefault true;
        shell = userAttrs.shell;
        uid = userAttrs.uid;
        extraGroups = lib.mkDefault userAttrs.groups;
        openssh.authorizedKeys.keys = sshKeys;
        hashedPasswordFile = config.sops.secrets."${username}/password".path;
        packages = [ pkgs.home-manager ];
      }
    ) config.base.users.usersConfiguration;

    # Sops
    sops.secrets =
      let
        mkUserPasswordSecret = username: {
          # The key name you want in NixOS:
          #   config.sops.secrets."username/password"
          #
          # This is easy to read and behaves exactly as you want.
          name = "${username}/password";

          value = {
            sopsFile = ../../../home/${username}/${host}/secrets.yml;
            key = "password";
            neededForUsers = true;
          };
        };
      in
      builtins.listToAttrs (map mkUserPasswordSecret (builtins.attrNames defaultUsers));

    # Home configuration creation
    lib.homeConfigurations = homeConfs;

    # Activate home manager rebuild
    home-manager.users = builtins.listToAttrs (
      map (username: {
        name = username;
        value = import ../../../home/${username}/${config.networking.hostName};

      }) users
    );
  };
}
