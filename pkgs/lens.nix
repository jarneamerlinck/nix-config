
{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pversion = "1.0.0";
  pname = "freelens";

  # src = fetchurl {
  #   url = "https://github.com/freelensapp/freelens/releases/download/v${version}/Freelens-${version}-linux-amd64.AppImage";
  #   hash = "sha256-Ic7Algr+8ZNNMp5WsaxbGhylkTwjpT/GABRnly4ghmw=";
  # };

  # appimageContents = appimageTools.extractType1 { inherit pname src; };
in

  {
  freelens = appimageTools.wrapType2 rec {
    name= "${pname}"; 
    version = "${pversion}";
    src = fetchurl {
      url = "https://github.com/freelensapp/freelens/releases/download/v${pversion}/Freelens-${pversion}-linux-amd64.AppImage";
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
      Name=Freelens
      Comment=Free and open-source Kubernetes IDE
      Exec=${pname}
      Icon=freelens
      Terminal=false
      Type=Application
      Categories=Development;Kubernetes;
      EOF


      mkdir -p $out/share/icons/hicolor/scalable/apps
      install -m 644 ${icon} $out/share/icons/hicolor/scalable/apps/freelens.png 
    '';


  
    meta = {
      description = "Free and open-source Kubernetes IDE";
      homepage = "https://github.com/freelensapp/freelens";
      downloadPage = "https://github.com/freelensapp/freelens/releases";
      # license = lib.licenses.asl20;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      # maintainers = with lib.maintainers; [ onny ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
