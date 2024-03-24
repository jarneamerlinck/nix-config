#default.nix
with import <nixpkgs> {}; {
  pullapiEnv = stdenv.mkDerivation {
    name = "eragon1442-flake";
    buildInputs = [
      neovim
      git
    ];
    NIX_CONFIG = "experimental-features = nix-command flakes";
    shellHook = ''
      cd ~
      rm -rf ./nix-config
      git clone --recurse-submodules https://github.com/jarneamerlinck/nix-config
      cd nix-config
      git submodule update --init --recursive
      ./deploy.sh
    '';
  };
}
