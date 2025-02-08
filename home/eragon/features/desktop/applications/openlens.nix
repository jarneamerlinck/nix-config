{  pkgs, ... }:{

  nixpkgs.overlays = [
      (final: prev: {
        openlens = prev.stdenv.mkDerivation rec {
          pname = "openlens";
          version = "6.5.2";  # Adjust to the latest release version
  
          src = prev.fetchurl {
            url = "https://github.com/MuhammedKalkan/OpenLens/releases/download/v${version}/OpenLens-${version}.AppImage";
            sha256 = "sha256-hash-of-the-file";  # Replace with the correct SHA-256
          };
  
          buildInputs = [ prev.patchelf ];
  
          installPhase = ''
            mkdir -p $out/bin
            cp ${src} $out/bin/openlens
            chmod +x $out/bin/openlens
            patchelf --set-interpreter $(cat ${prev.stdenv.shell}) $out/bin/openlens
          '';
  
          meta = with prev.lib; {
            description = "OpenLens – Kubernetes IDE";
            homepage = "https://github.com/MuhammedKalkan/OpenLens";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };
      })
    ];
  home.packages = with pkgs; [
    openlens
  ];
}
