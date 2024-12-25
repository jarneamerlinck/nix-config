{ pkgs, config, ... }: {

  home = {
    packages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
  };
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gtk"
          "kde"
        ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-kde
    ];
  };

}
