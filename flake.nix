{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Hardware
    hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixarr = {
    #   url = "github:rasmus-kirk/nixarr";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    ...
  } @ inputs:
  let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    inherit lib;

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    # templates = import ./templates;

    overlays = import ./overlays { inherit inputs outputs; };
    # hydraJobs = import ./hydra.nix { inherit inputs outputs; };

    packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
    devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
    formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
        vm1 = lib.nixosSystem {
          modules = [ ./hosts/vm1 ];
          specialArgs = { inherit inputs outputs; };
        };
        ash = lib.nixosSystem {
          modules = [ ./hosts/ash ];
          specialArgs = { inherit inputs outputs; };
        };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # VM
      "eragon@vm1" = lib.homeManagerConfiguration {
          modules = [ ./home/eragon/vm1.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
      };
      "eragon@ash" = lib.homeManagerConfiguration {
          modules = [ ./home/eragon/ash.nix ];
          pkgs = pkgsFor.aarch64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
