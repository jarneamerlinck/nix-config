#default.nix
with import <nixpkgs> {}; {
  pullapiEnv = stdenv.mkDerivation {
    name = "update";
    buildInputs = [
      neovim
      git
    ];
    shellHook = ''
      cd ~
      rm -rf ./nix-config
      git clone --recurse-submodules https://github.com/jarneamerlinck/nix-config
      cd nix-config
      git submodule update --init --recursive
      ./deploy.sh $HOST
    '';
  };
}
