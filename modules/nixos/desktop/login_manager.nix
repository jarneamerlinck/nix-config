{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{

  options = {

    desktop.loginManager = lib.mkOption {
      type = lib.types.submodule {
        options = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Enable login manager module module";
          };

          type = lib.mkOption {
            type = lib.types.enum [
              "greetd"
              "gdm"
              "sddm"
            ];
            default = "greetd";
            description = "Login manager to use";
          };

          theme = lib.mkOption {
            type = lib.types.string;
            default = "sddm-tokyo-night";
            description = "Theme to use for the login manager. (only for sddm atm)";
          };
        };
      };
    };
  };

  config = lib.mkMerge [

    (lib.mkIf (config.desktop.loginManager.type == "greetd") {

      services.greetd = {
        enable = true;
        settings = {
          default_session.command = ''
            ${pkgs.tuigreet}/bin/tuigreet \
              --time \
              --asterisks \
              --user-menu \
              --cmd "/home/\$USER/.nix-profile/bin/greetd-session"
          '';
        };
      };
    })

    (lib.mkIf (config.desktop.loginManager.type == "sddm") {

      services = {
        xserver.displayManager.sddm = {
          enable = true;
          autoNumlock = true;
          settings.General.DisplayServer = "x11-user";
          theme = "${config.desktop.loginManager.theme}";
        };
      };
      environment.systemPackages = with pkgs; [
        sddm-themes."${config.desktop.loginManager.theme}"
        libsForQt5.qt5.qtsvg
        libsForQt5.qt5ct
        libsForQt5.qt5.qtgraphicaleffects
        libsForQt5.qt5.qtquickcontrols
      ];
    })
    (lib.mkIf (config.desktop.loginManager.type == "gdm") {

      services.xserver.displayManager.gdm = {
        enable = true;
      };
    })
  ];
}
