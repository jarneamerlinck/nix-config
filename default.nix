# default.nix
with import <nixpkgs> { };
{
  pullapiEnv = stdenv.mkDerivation {
    name = "eragon1442-system-build-flake";
    buildInputs = [
      neovim
      git
      age
      sops
      nh
    ];
    NIX_CONFIG = "experimental-features = nix-command flakes";
    shellHook = ''
      git clone  https://github.com/jarneamerlinck/nix-config ~/nix-config;
      cd ~/nix-config
    '';
  };
}
