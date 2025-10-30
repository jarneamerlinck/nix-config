{ stdenv, fetchFromGitHub, fetchzip, }: {
  # use nix-prefetch-git to get the hash
  fallout-grub-theme = stdenv.mkDerivation rec {
    pname = "fallout-grub-theme";
    version = "e8433860b11abb08720d7c32f5b9a2a534011bca";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/grub/themes/${pname}
      cp -aR * $out/share/grub/themes/${pname}
    '';
    src = fetchFromGitHub {
      owner = "shvchk";
      repo = "fallout-grub-theme";
      rev = "${version}";
      sha256 = "sha256-mvb44mFVToZ11V09fTeEQRplabswQhqnkYHH/057wLE=";
    };
  };

  distro-grub-themes = stdenv.mkDerivation rec {
    pname = "distro-grub-themes";
    version = "v3.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/grub/themes/${pname}
      cp -aR * $out/share/grub/themes/${pname}
    '';
    src = fetchzip {
      url =
        "https://github.com/AdisonCavani/distro-grub-themes/releases/download/${version}/nixos.tar";
      sha256 = "10ai28hz5kivk2qbsv3866vl92cmx1bwvn7bq0apanmcmqs1f019";
      stripRoot =
        false; # hint: Pass stripRoot=false; to fetchzip to assume flat list of files.
    };
  };

  xenlism-grub-nixos = stdenv.mkDerivation rec {
    pname = "xenlism-grub-nixos";
    version = "40ac048df9aacfc053c515b97fcd24af1a06762f";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/grub/themes/${pname}
      cp -aR xenlism-grub-1080p-nixos/Xenlism-Nixos/* $out/share/grub/themes/${pname}
    '';
    src = fetchFromGitHub {
      owner = "xenlism";
      repo = "Grub-themes";
      rev = "${version}";
      sha256 = "sha256-ProTKsFocIxWAFbYgQ46A+GVZ7mUHXxZrvdiPJqZJ6I=";
    };
  };
}
