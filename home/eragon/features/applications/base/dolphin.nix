{ pkgs, ... }:
{
  stylix.targets.kde.enable = true;
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.gwenview
  ];
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
      "image/bmp" = [ "org.kde.gwenview.desktop" ];
      "image/tiff" = [ "org.kde.gwenview.desktop" ];
      "image/svg+xml" = [ "org.kde.gwenview.desktop" ];
      "image/avif" = [ "org.kde.gwenview.desktop" ];
      "image/heic" = [ "org.kde.gwenview.desktop" ];
      "image/x-xpixmap" = [ "org.kde.gwenview.desktop" ];
    };
  };
}
