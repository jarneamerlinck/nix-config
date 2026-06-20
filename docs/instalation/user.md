# Instalation: User

## Goal

Add user to the nix flake and fix sops

## 1. Create config for user


### Password

the password can be set depending if you want to fully manage the password with nix or just the inital password

for inital password use: `users.users.<name>.initialHashedPassword`1


for fully managed passwords: `users.users.<name>.hashedPasswordFile`

> Important: for inital it's the password itself
> for `users.users.<name>.hashedPasswordFile` it's the path to the sops file
> `  users.mutableUsers = true; # Only enable if you set password outside sops or from nix-config
`

### Without home manager

Adding an new user without home manager is simple.

1. Create `hosts/base/users/<name>/default.nix`

    The nix code below will do the following things

    - create the user
    - set defautl shell for user
    - set password for user

    ```nix
    {
      pkgs,
      config,
      inputs,
      outputs,
      ...
    }:
    let
      ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
      username = "<name>";
    in
    {
      users.mutableUsers = true; # Only enable if you set password outisde sops or from nix-config
      users.users."${username}" = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [
          # "wheel" # Add this if the user is an admin user
          "video"
          "audio"
          "mounts"
        ];
        ++ ifTheyExist [
          "network"
        ];

        hashedPasswordFile = config.sops.secrets."${username}/password".path;
      };

      sops.secrets."${username}/password" = {
        sopsFile = ./secrets.yml;
        neededForUsers = true;
      };
    }

    ```

2. Include the file in the host

    ```nix
    { inputs, lib, ... }:
    {
      imports = [
        ./hardware-configuration.nix

        ../base
        ../base/users/<name>
      ];
      networking = {
        hostName = "<hostname>";
        useDHCP = lib.mkDefault true;
      };

      system.stateVersion = "26.05";
    }

    ```


### With Home manager


Adding an new user with home manager is a bit more complex

1. create `hosts/base/users/<name>/default.nix`

    The nix code below will do the following things

    - create the user
    - set defautl shell for user
    - set password for user

    - get ssh keys from the known hosts and add them to ssh authorized hosts
    - enable home manager
    - load the correct home manager config for the "targeted" host

    ```nix
    {
      pkgs,
      config,
      inputs,
      outputs,
      ...
    }:
    let
      ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
      username = "<name>";
      homePath = ../../../../home/${username};
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

    in
    {
      users.mutableUsers = true; # Only enable if you set password outside sops or from nix-config
      users.users."${username}" = {
        isNormalUser = true;
        shell = pkgs.bash;
        extraGroups = [
          # "wheel" # Add this if the user is an admin user
          "video"
          "audio"
          "mounts"
        ]
        ++ ifTheyExist [
          "network"
        ];
        openssh.authorizedKeys.keys = sshKeys;
        hashedPasswordFile = config.sops.secrets."${username}/password".path;
        packages = [ pkgs.home-manager ];
      };

      sops.secrets."${username}/password" = {
        sopsFile = ./secrets.yml;
        neededForUsers = true;
      };

      lib.homeConfigurations."${username}@${config.networking.hostName}" = lib.homeManagerConfiguration {
        modules = [ ../../../../home/${username}/${config.networking.hostName}.nix ];
        pkgs = pkgsFor."${config.nixpkgs.hostPlatform.system}";
        extraSpecialArgs = { inherit inputs outputs; };
      };

      home-manager.users."${username}" =
        import ../../../../home/${username}/${config.networking.hostName};

    }

    ```

2. Include the file in the host

```nix
{ inputs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../base
    ../base/users/<name>
  ];
  networking = {
    hostName = "<hostname>";
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = "26.05";
}

```

3. Create the home manager file `home/<username>/<hostname>/default.nix`

    This file fully depends on the code structure the home manager config.
    Below is an example of what could be in it

    ```nix
    {
      inputs,
      lib,
      pkgs,
      config,
      outputs,
      ...
    }:
    {
      imports = [
        # inputs.impermanence.nixosModules.home-manager.impermanence
        inputs.sops-nix.homeManagerModule
      ]
      ++ (builtins.attrValues outputs.homeManagerModules);
      nixpkgs = {
        overlays = builtins.attrValues outputs.overlays;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      nix = {
        package = lib.mkDefault pkgs.nix;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          warn-dirty = false;
        };
      };

      systemd.user.startServices = "sd-switch";

      programs = {
        home-manager.enable = true;
        git.enable = true;
      };

      home = {
        username = lib.mkDefault "eragon";
        homeDirectory = lib.mkDefault "/home/${config.home.username}";
        stateVersion = lib.mkDefault "26.05";
        sessionPath = [ "$HOME/.local/bin" ];
        sessionVariables = {
          FLAKE = "${config.home.homeDirectory}/nix-config";
          NH_FLAKE = "${config.home.homeDirectory}/nix-config";
        };
      };
    }

    ```

## 3. Sops

For sops see (sops)[../sops.md#new-user]

## 4. Rebuild the host

On the host use an admin user to run

```bash
git checkout feature/new-user-branch
rebuildf
```

Validate that the user can login
