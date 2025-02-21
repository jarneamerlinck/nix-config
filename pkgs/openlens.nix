{ stdenv, fetchFromGitHub, nodejs, yarn, makeWrapper, electron, gcc, jq, curl, patchelf, pkgs }:
{
  openlens = pkgs.stdenv.mkDerivation rec {
    pname = "openlens";
    version = "6.5.2-366";
    
    src = pkgs.fetchurl {
      url = "https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.5.2-366/OpenLens-6.5.2-366.x86_64.AppImage";
      sha256 = "sha256-ZAltAS/U/xh4kCT7vQ+NHAzWV7z0uE5GMQICHKSdj8k="; 
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/128x128/apps
      install -m 755 $src $out/bin/openlens
      ln -s $out/bin/openlens $out/bin/OpenLens
      
      cat > $out/share/applications/openlens.desktop <<EOF
      [Desktop Entry]
      Name=OpenLens
      Exec=$out/bin/openlens
      Icon=openlens
      Type=Application
      Categories=Development;
      EOF
    '';

  };
}

