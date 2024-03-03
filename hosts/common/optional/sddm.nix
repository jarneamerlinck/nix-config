{ pkgs, lib, config, ... }:
{
  # users.extraUsers.greeter = {
  #   packages = [
  #     # gtkTheme.package
  #     # iconTheme.package
  #   ];
  #   # For caching and such
  #   home = "/tmp/greeter-home";
  #   createHome = true;
  # };
  #
  # programs.regreet = {
  #   enable = true;
  #   settings = {
  #     GTK = {
  #       icon_theme_name = "Papirus";
  #       # theme_name = gtkTheme.name;
  #     };
  #     # background = {
  #     #   path = wallpaper;
  #     #   fit = "Cover";
  #     # };
  #   };
  # };
  services = {
    xserver.displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      settings.General.DisplayServer = "x11-user";
      theme = "sddm-tokyo-night";
    };
  };
  environment.systemPackages = with pkgs; [
    sddm-themes.sddm-tokyo-night
    libsForQt5.qt5.qtsvg
    libsForQt5.qt5ct
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols
    # libsForQt5.qt5.qtquickcontrols2
  ];
}
