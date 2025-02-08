{ stdenv, fetchFromGitHub, nodejs, yarn, makeWrapper, electron, gcc, jq, curl, patchelf, pkgs }:
{

  openlens =  stdenv.mkDerivation rec {
    pname = "openlens";
    version = "6.5.2";

    src = fetchFromGitHub {
      owner = "lensapp";
      repo = "lens";
      rev = "v${version}";
      sha256 = "sha256-9qxsaKYqDV5LLzVoIngGyTggbiOj2k8zmqqWsjlPP78=";
    };
  
    nativeBuildInputs = [ nodejs yarn makeWrapper gcc jq curl patchelf ];
    buildInputs = [
      electron
      pkgs.nodejs_18
      yarn
      gcc
    ];
  
    # unpackPhase = "tar xvf ${src} --strip-components=1";
  
    buildPhase = ''
      rm package-lock.json
      npm install
      npm run all:install
  
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

