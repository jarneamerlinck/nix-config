{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./zsh.nix
    ./nvim.nix
    ./nix.nix
    ./openssh.nix
    ./package-list.nix
    ./mdadm.nix
    ./mount_points.nix
    ./sops.nix
    ./hardware-packages.nix
    ./security.nix

  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  nixpkgs = {
      overlays = [
        # Add overlays your own flake exports (from overlays and pkgs dir):
        outputs.overlays.additions
        outputs.overlays.modifications
        # outputs.overlays.unstable-packages

        # You can also add overlays exported from other flakes:
        # neovim-nightly-overlay.overlays.default

        # Or define it inline, for example:
        # (final: prev: {
        #   hi = final.hello.overrideAttrs (oldAttrs: {
        #     patches = [ ./change-hello-to-hi.patch ];
        #   });
        # })
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Fix for qt6 plugins
  # TODO: maybe upstream this?
  environment.profileRelativeSessionVariables = {
    QT_PLUGIN_PATH = [ "/lib/qt-6/plugins" ];
  };

  # Set default console keyboard
  console.keyMap = "be-latin1";

  hardware.enableRedistributableFirmware = true;

  # Increase open file limit for sudoers
  security.pam.loginLimits = [
    {
      domain = "@wheel";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@wheel";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];
  users.groups.mounts = {
    name = "mounts";
    gid = 1442; # Group ID, you can choose a suitable ID
  };
    # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

}
