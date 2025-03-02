{ stdenv, fetchFromGitHub, nodejs, yarn, makeWrapper, electron, gcc, jq, curl, patchelf, pkgs }:
{
  freelens = pkgs.stdenv.mkDerivation rec {

    pname = "freelens";
    version = "1.0.0";

    src = builtins.fetchurl {
      url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
      sha256 = "sha256-Ic7Algr+8ZNNMp5WsaxbGhylkTwjpT/GABRnly4ghmw=";
    };
    icon = pkgs.fetchurl {
      url = "https://avatars.githubusercontent.com/u/172038998";
      sha256 = "sha256-ayIriBfFiPCCpP059ieqG/1v+97e5aLYfAkOpC8PowM="; # Replace with actual hash
    };
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin

      curl -L -o $out/bin/freelens.AppImage https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage

      cat > $out/bin/freelens <<EOF
      #!/bin/sh
      exec ${pkgs.appimage-run}/bin/appimage-run $out/bin/freelens.AppImage
      EOF
      chmod +x $out/bin/freelens

      # Create desktop entry
      mkdir -p $out/share/applications
      cat > $out/share/applications/freelens.desktop <<EOF
      [Desktop Entry]
      Name=Freelens
      Comment=Free and open-source kubernetes IDE
      Exec="$out/bin/freelens"
      Icon=freelens
      Terminal=false
      Type=Application
      Categories=coding;kubernetes;
      EOF

      mkdir -p $out/share/icons/hicolor/scalable/apps
      install -m 644 ${icon} $out/share/icons/hicolor/scalable/apps/freelens.png 
 
    '';

    nativeBuildInputs = [ pkgs.appimage-run pkgs.curl ];

    meta = with pkgs.lib; {
      description = "Free and open-source photography workflow application";
      homepage = "https://github.com/freelensapp/freelens";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };
}

