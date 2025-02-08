{ stdenv, fetchFromGitHub, nodejs, yarn, makeWrapper }:
{
  openlens = stdenv.mkDerivation rec {
    pname = "openlens";
    version = "6.5.2-366";
  
    src = fetchFromGitHub {
      owner = "MuhammedKalkan";
      repo = "OpenLens";
      rev = "v${version}";
      sha256 = "sha256-tg6XeeX5R3aZpmo+o9OJE/LciJVnBg36l6d7BE2LSM8=";
    };
  
    buildInputs = [ nodejs yarn makeWrapper ];
  
    buildPhase = ''
      yarn install
      yarn build
    '';
  
    installPhase = ''
      mkdir -p $out/bin
      cp -r build/* $out/bin
      ln -s $out/bin/openlens $out/bin/openlens-cli
    '';
  };
}
