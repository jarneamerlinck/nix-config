{ config, pkgs, ... }:
{

  imports = [
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
  # QT_QPA_PLATFORMTHEME=gtk3
  # Shell and Bar.qml need to be in the same file to help imports
  xdg.configFile = {
    "quickshell/shell.qml".text =
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
    "quickshell/Bar.qml".text = ''
      import Quickshell
      import Quickshell.Wayland
      import Quickshell.Io
      import Quickshell.I3
      import QtQuick
      import QtQuick.Layouts

      PanelWindow {
          id: root

          // Theme (Overwritten from shell.qml)
          property color colBg: "#251724"
          property color colFg: "#dbe3f0"
          property color colMuted: "#969fa8"
          property color colCyan: "#89919c"
          property color colBlue: "#88929c"
          property color colYellow: "#8b919d"
          property string fontFamily: "FiraCode Nerd Font Sans"
          property int fontSize: 14

          anchors.top: true
          anchors.left: true
          anchors.right: true
          implicitHeight: 30
          color: colBg

          RowLayout {
              anchors.fill: parent
              anchors.margins: 8

              Workspaces {
                  colBg: colBg
                  colFg: colFg
                  colMuted: colMuted
                  colCyan: colCyan
                  colBlue: colBlue
                  colYellow: colYellow
                  fontFamily: fontFamily
                  fontSize: fontSize
              }

              Item {
                  Layout.fillWidth: true
              }

              SystemStatus {
                  colBg: colBg
                  colFg: colFg
                  colMuted: colMuted
                  colCyan: colCyan
                  colBlue: colBlue
                  colYellow: colYellow
                  fontFamily: fontFamily
                  fontSize: fontSize
              }

              Item {
                  Layout.fillWidth: true
              }

              SessionStatus {
                  colBg: colBg
                  colFg: colFg
                  colMuted: colMuted
                  colCyan: colCyan
                  colBlue: colBlue
                  colYellow: colYellow
                  fontFamily: fontFamily
                  fontSize: fontSize
              }
          }
      }
    '';
  };
}
