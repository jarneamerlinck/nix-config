{
  pkgs,
  config,
  inputs,
  outputs,
  ...
}:
let
  username = "kodi";
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
  users.mutableUsers = true; # Only enable if you set password from sops or from nix-config
  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.bash;
    # uid = 1003;
    extraGroups = [
      "data"
      "video"
      "audio"
      "input"
    ];

    packages = [ pkgs.home-manager ];
  };

  lib.homeConfigurations."${username}@${config.networking.hostName}" = lib.homeManagerConfiguration {
    modules = [ ../../../../home/${username}/${config.networking.hostName}.nix ];
    pkgs = pkgsFor."${config.nixpkgs.hostPlatform.system}";
    extraSpecialArgs = { inherit inputs outputs; };
  };

  home-manager.users."${username}" =
    import ../../../../home/${username}/${config.networking.hostName};

  # services.geoclue2.enable = true;
  # security.pam.services = { swaylock = { }; };
}
