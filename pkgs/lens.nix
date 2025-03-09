{ stdenv, fetchurl, appimage-run, curl, pkgs }:
{
  freelens = stdenv.mkDerivation rec {
  pname = "freelens";
  version = "1.0.0";

  src = fetchurl {
    # url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
    url = "https://github.com/freelensapp/freelens/releases/download/v1.0.0/Freelens-1.0.0-linux-amd64.AppImage";
    sha256 = "sha256-Ic7Algr+8ZNNMp5WsaxbGhylkTwjpT/GABRnly4ghmw=";
  };

  icon = fetchurl {
    url = "https://avatars.githubusercontent.com/u/172038998";
    sha256 = "sha256-ayIriBfFiPCCpP059ieqG/1v+97e5aLYfAkOpC8PowM=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 ${src} $out/bin/freelens.AppImage

    # Wrapper script to run the AppImage
    cat > $out/bin/freelens <<EOF
    #!/bin/sh
    exec ${appimage-run}/bin/appimage-run $out/bin/freelens.AppImage
    EOF
    chmod +x $out/bin/freelens

    # Install icon
    mkdir -p $out/share/icons/hicolor/scalable/apps
    install -m 644 ${icon} $out/share/icons/hicolor/scalable/apps/freelens.png 

    # Create desktop entry
    mkdir -p $out/share/applications
    cat > $out/share/applications/freelens.desktop <<EOF
    [Desktop Entry]
    Name=Freelens
    Comment=Free and open-source Kubernetes IDE
    Exec=$out/bin/freelens
    Icon=freelens
    Terminal=false
    Type=Application
    Categories=Development;Kubernetes;
    EOF
  '';

  nativeBuildInputs = [ curl ];
  propagatedBuildInputs = [ appimage-run ]; # Needed at runtime

  meta = with pkgs.lib; {
    description = "Free and open-source Kubernetes IDE";
    homepage = "https://github.com/freelensapp/freelens";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
  };
}
