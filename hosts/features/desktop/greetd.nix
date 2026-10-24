{ pkgs, ... }:
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
  programs.regreet.enable = true;
  environment.variables = {
    XKB_DEFAULT_LAYOUT = "be";
  };

  # Register the Wayland session so ReGreet finds de-session.desktop
  services.displayManager.sessionPackages = [ deSessionPackage ];
}
