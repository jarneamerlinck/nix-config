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
  perUserSecrets = builtins.mapAttrs (username: _: {
    sopsFile = ../../../home/${username}/${host}/secrets.yml;
    neededForUsers = true;
  }) defaultUsers;

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
  # Include home manager for user within the system build
  hmUsers = builtins.mapAttrs (username: _: import ../../../../home/${username}/${host}) enabledUsers;
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
              lib.types.attrsOf {
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
                  type = lib.types.str;
                  default = pkgs.bash;
                  description = "Default shell of the user";
                };
                uid = lib.mkOption {
                  type = lib.types.int;
                  description = "Unique ID of the user";
                };
              }
            );
            default = defaultUsers;
            description = ''
              Dictionary of users keyed by username.
              Each user must have:
                - uid: string
            '';
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
        isNormalUser = true;
        shell = userAttrs.shell;
        uid = userAttrs.uid;
        extraGroups = userAttrs.groups;
        openssh.authorizedKeys.keys = sshKeys;
        hashedPasswordFile = config.sops.secrets."${username}/password".path;
        packages = [ pkgs.home-manager ];
      }
    ) config.base.users.usersConfiguration;

    # Sops
    sops.secrets = perUserSecrets;

    # Home configuration creation
    lib.homeConfigurations = homeConfs;

    # Activate home manager rebuild
    home-manager.users = hmUsers;

  };
}
