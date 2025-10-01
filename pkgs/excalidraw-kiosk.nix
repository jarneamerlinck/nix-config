{
  makeDesktopItem,
  fetchurl,
}:
let
  pkgName = "excalidraw";
in
{

  excalidraw = makeDesktopItem {
    name = "${pkgName}";
    exec = "firefox --kiosk --new-window http://localhost:38080";
    icon = fetchurl {
      url = "https://avatars.githubusercontent.com/u/59452120";
      sha256 = "a8e40476d4f4e4a0155b0accc29b28779ec309ad552465a9683ca16b7cab4877";
    };
    desktopName = "${pkgName}";
    genericName = "${pkgName}";
    comment = "Open excalidraw in kiosk mode";
  };
}
