#default.nix
with import <nixpkgs> {}; {
  pullapiEnv = stdenv.mkDerivation {
    name = "eragon1442-system-build-flake";
    buildInputs = [
      neovim
      git
    ];
    NIX_CONFIG = "experimental-features = nix-command flakes";
    shellHook = ''
      git clone --recurse-submodules https://github.com/jarneamerlinck/nix-config
      cd nix-config
      git submodule update --init --recursive
      git checkout feature/qemu
      ./deploy.sh
    '';
  };
}
