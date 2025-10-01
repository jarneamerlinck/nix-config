{ stdenv, fetchFromGitHub }:
{
  sddm-themes.sddm-sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark";
    version = "v1.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/${pname}
    '';
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };
  sddm-themes.sddm-tokyo-night = stdenv.mkDerivation rec {
    pname = "sddm-tokyo-night";
    version = "320c8e74ade1e94f640708eee0b9a75a395697c6";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/${pname}
    '';
    src = fetchFromGitHub {
      owner = "rototrash";
      repo = "tokyo-night-sddm";
      rev = "${version}";
      sha256 = "sha256-JRVVzyefqR2L3UrEK2iWyhUKfPMUNUnfRZmwdz05wL0=";
    };
  };

}
