{ stdenv, fetchFromGitHub, nodejs, yarn, makeWrapper }:
{
  openlens = stdenv.mkDerivation rec {
    pname = "openlens";
    version = "6.5.2-366"; # Replace with the desired version.
  
    src = fetchFromGitHub {
      owner = "MuhammedKalkan";
      repo = "OpenLens";
      rev = "v${version}";
      sha256 = "0xxxxxxxxxxxxxxxxxxxxxxxxxxxx"; # Replace with the correct hash.
    };
  
    buildInputs = [ nodejs yarn makeWrapper ];
  
    unpackPhase = "tar xvf ${src} --strip-components=1";
  
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
