{
  lib,
  addonDir,
  buildKodiAddon,
  fetchFromGitHub,
  kodi,
  python3,
}:

buildKodiAddon rec {
  pname = "web-viewer";
  namespace = "plugin.program.web.viewer";
  version = "b7d7081936f93c1271972782a4045ce3a272cae3";

  src = fetchFromGitHub {
    owner = "xbmc";
    repo = "plugin.program.web.viewer";
    rev = "${version}";
    sha256 = "sha256-6g/LorVHXYL+zyCdrZQpVl1jB6KcHkp6WwmI4GS1R5c=";
  };

  nativeBuildInputs = [
    python3
  ];

  meta = {
    homepage = "https://kodi.wiki/view/Add-on:Web_Viewer";
    description = "View web pages directly inside Kodi";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    teams = [ lib.teams.kodi ];
  };
}
