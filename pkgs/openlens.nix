{ stdenv, fetchFromGitHub, nodejs, yarn, makeWrapper, electron, gcc, jq, curl, patchelf }:
{

  openlens =  stdenv.mkDerivation rec {
    pname = "openlens";
    version = "6.5.2";

    src = fetchFromGitHub {
      owner = "lensapp";
      repo = "lens";
      rev = "v${version}";
      sha256 = "sha256-tg6XeeX5R3aZpmo+o9OJE/LciJVnBg36l6d7BE2LSM8=";
    };
  
    # nativeBuildInputs = [ nodejs yarn makeWrapper gcc jq curl patchelf ];
    buildInputs = [
      electron
      nodejs
      yarn
      gcc
    ];
  
    # unpackPhase = "tar xvf ${src} --strip-components=1";
  
    buildPhase = ''
      ls -lhi
      cd open-lens
      npm install
      npm run all:install
      cd ..
  
      mkdir -p open-lens/node_modules
      npx nx run open-lens:build:app
    '';
  
    installPhase = ''
      mkdir -p $out/bin
      cp -r lens/open-lens/dist/* $out/bin
      ln -s $out/bin/openlens $out/bin/openlens-cli
    '';
  
  };
}

