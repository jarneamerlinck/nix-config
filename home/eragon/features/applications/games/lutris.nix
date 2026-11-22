{ pkgs, ... }:
{
  home.packages = [
    (pkgs.lutris.override {
      extraPkgs = p: [
        p.wineWowPackages.staging
        p.pixman
        p.libjpeg
        p.gnome.zenity
      ];
    })
  ];
}
