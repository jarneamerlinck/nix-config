{ inputs, lib, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    nh
  ];
  nix = {
    # TODO
    # https://github.com/NixOS/nix/issues/9579
    # https://github.com/NixOS/nix/pull/9547
    # package = pkgs.nixVersions.nix_2_18;

    settings = {
      # substituters = [
      #   "https://cache.m7.rs"
      # ];
      # trusted-public-keys = [
      #   "cache.m7.rs:kszZ/NSwE/TjhOcPPQ16IuUiuRSisdiIwhKZCxguaWg="
      # ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" "repl-flake" ];
      warn-dirty = false;
      system-features = [ "kvm" "big-parallel" "nixos-test" ];
      flake-registry = ""; # Disable global flake registry
    };
    gc = { # garbage collection
      automatic = true;
      dates = "weekly";
      # Keep the last 3 generations
      options = "--delete-older-than +3";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
    # nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);


    # Add nixpkgs input to NIX_PATH
    # This lets nix2 commands still use <nixpkgs>
    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  };
}
