{ pkgs }:
let
  wallpaperList = pkgs.lib.importJSON ./list.json;

  convertMp4ToGif = wallpaper: pkgs.stdenv.mkDerivation {
    name = "${wallpaper.name}.gif";
    src = pkgs.fetchurl {
      inherit (wallpaper) sha256;
      name = "${wallpaper.name}.gif";
      url = "https://${wallpaper.website}/${wallpaper.id}.mp4";
    };

    nativeBuildInputs = [ pkgs.ffmpeg ];

    unpackPhase = "true";
    installPhase = ''
      # mkdir -p $out
      ffmpeg -i $src -vf "fps=10" "$out"
    '';
  };

in
pkgs.lib.listToAttrs (
  map (wallpaper:
    let
      value =
        if wallpaper.ext == "mp4" then
          convertMp4ToGif wallpaper
        else
          pkgs.fetchurl {
            inherit (wallpaper) sha256;
            name = "${wallpaper.name}.${wallpaper.ext}";
            url = "https://${wallpaper.website}/${wallpaper.id}.${wallpaper.ext}";
          };
    in
    {
      inherit (wallpaper) name;
      value = value;
    }
  ) wallpaperList
)

