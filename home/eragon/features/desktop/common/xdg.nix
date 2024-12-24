{ pkgs, config, ... }: {

  home = {
    packages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
    ];
  };
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
}
