{ pkgs, lib, ... }:
let
  deSessionPackage =
    pkgs.writeTextDir "share/wayland-sessions/de-session.desktop" ''
      [Desktop Entry]
      Name=User Desktop (de-session)
      Comment=Launch user-configured desktop session
      Exec=de-session
      Type=Application
    ''
    // {
      providedSessions = [ "de-session" ];
    };
in
{
  services.displayManager.regreet = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    settings = {
      background = {
        path = lib.mkDefault "${pkgs.wallpapers.nixos-logo}";
        # Optional: "Fill", "Contain", "Cover", or "Scale"
        fit = "Cover";
      };
    };
  };
  environment.variables = {
    XKB_DEFAULT_LAYOUT = "be";
  };

  # Register the Wayland session so ReGreet finds de-session.desktop
  services.displayManager.sessionPackages = [ deSessionPackage ];
}
