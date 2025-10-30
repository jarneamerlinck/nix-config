{ lib, appimageTools, fetchurl, pkgs, }:
let
  pkgVersion = "1.0.0";
  pkgName = "freelens";
  pkgRepo = "https://github.com/freelensapp/freelens";

in {
  freelens = appimageTools.wrapType2 rec {
    pname = "${pkgName}";
    version = "${pkgVersion}";
    src = fetchurl {
      url =
        "${pkgRepo}/releases/download/v${pkgVersion}/Freelens-${pkgVersion}-linux-amd64.AppImage";
      hash = "sha256-Ic7Algr+8ZNNMp5WsaxbGhylkTwjpT/GABRnly4ghmw=";
    };

    icon = fetchurl {
      url = "https://avatars.githubusercontent.com/u/172038998";
      sha256 = "sha256-ayIriBfFiPCCpP059ieqG/1v+97e5aLYfAkOpC8PowM=";
    };

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/freelens.desktop <<EOF
      [Desktop Entry]
      Name=${pkgName}
      Comment=Free and open-source Kubernetes IDE
      Exec=${pkgName}
      Icon=${pkgName}
      Terminal=false
      Type=Application
      Categories=Development;Kubernetes;
      EOF

      mkdir -p $out/share/icons/hicolor/scalable/apps
      install -m 644 ${icon} $out/share/icons/hicolor/scalable/apps/${pkgName}.png
    '';

    meta = with pkgs.lib; {
      description = "Free and open-source Kubernetes IDE";
      homepage = "${pkgRepo}";
      downloadPage = "${pkgRepo}/releases";
      license = licenses.mit;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      maintainers = with lib.maintainers; [ ];
      platforms = platforms.linux;
    };
  };
}
