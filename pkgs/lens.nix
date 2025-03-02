{ stdenv, fetchFromGitHub, nodejs, yarn, makeWrapper, electron, gcc, jq, curl, patchelf, pkgs }:
{
  freelens = pkgs.stdenv.mkDerivation rec {

    pname = "freelens";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
      sha256 = "sha256-Ic7Algr+8ZNNMp5WsaxbGhylkTwjpT/GABRnly4ghmw=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      install -m 755 $src $out/bin/freelens
    '';

    meta = with pkgs.lib; {
      description = "Free and open-source photography workflow application";
      homepage = "https://github.com/freelensapp/freelens";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };
}

