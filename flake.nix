{
  description = "Nixos configurations for all used devices.";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Hardware
    hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim.url = "github:jarneamerlinck/kickstart.nvim";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
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
          modules = [
            ./hosts/vm1
            disko.nixosModules.disko
            { disko.devices.disk.boot_disk.device = "/dev/vda"; }
          ];
          specialArgs = { inherit inputs outputs; };
        };
        ash = lib.nixosSystem {
          modules = [
            ./hosts/ash
            disko.nixosModules.disko
            { disko.devices.disk.boot_disk.device = "/dev/vda"; }
          ];
          specialArgs = { inherit inputs outputs; };
        };
        atlas = lib.nixosSystem {
          modules = [
            ./hosts/atlas
            disko.nixosModules.disko
            {
              disko.devices.disk.boot_one.device = "/dev/vda";
              disko.devices.disk.boot_two.device = "/dev/vdb";

              # disko.devices.disk.nvme1.device = "/dev/sda";
              disko.devices.disk.raid_d1.device = "/dev/sdb";
              disko.devices.disk.raid_d2.device = "/dev/sdc";
              disko.devices.disk.raid_d3.device = "/dev/sdd";
              disko.devices.disk.raid_d4.device = "/dev/sde";
              disko.devices.disk.raid_d5.device = "/dev/sdf";
              disko.devices.disk.raid_d6.device = "/dev/sdg";
              # disko.devices.disk.raid10_array.device = [
              #   "/dev/sdb"
              #   "/dev/sdc"
              #   "/dev/sdd"
              #   "/dev/sde"
              #   "/dev/sdf"
              #   "/dev/sdg" ];
            }
          ];
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
      "eragon@atlas" = lib.homeManagerConfiguration {
          modules = [ ./home/eragon/atlas.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
      };
    };
  };
}
