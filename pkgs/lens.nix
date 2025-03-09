
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
      # extraInstallCommands = ''
      #   substituteInPlace $out/share/applications/${pname}.desktop \
      #     --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
      # '';
  
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
