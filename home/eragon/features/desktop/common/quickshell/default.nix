{ config, pkgs, ... }:
{

  imports = [
    ./bar.nix
    ./sessionStatus.nix
    ./systemStatus.nix
    ./workspaces.nix

  ];
  home.packages = with pkgs; [
    libsForQt5.qt5.qtbase
    libsForQt5.qt5.qtdeclarative
    libsForQt5.qt5.qtgraphicaleffects
    kdePackages.qt5compat
  ];

  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."quickshell/shell.qml".text =
    let
      fontSize = toString config.stylix.fonts.sizes.desktop;
      fontFamily = toString config.stylix.fonts.sansSerif.name;
      colors = config.lib.stylix.colors.withHashtag;
    in
    ''
      import Quickshell
      Scope {
        Bar {
          colBg: "${colors.base00}"
          colFg: "${colors.base05}"
          colMuted: "${colors.base03}"
          colCyan: "${colors.base0C}"
          colBlue: "${colors.base0D}"
          colYellow: "${colors.base0A}"
          fontFamily: "${fontFamily}"
          fontSize: ${toString fontSize}
        }
      }
    '';
}
