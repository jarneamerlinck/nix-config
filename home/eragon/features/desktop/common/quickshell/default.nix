{
  config,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    # ./sessionStatus.nix
    # ./systemStatus.nix
    # ./workspaces.nix

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
  # home.sessionVariables = {
  #   QT_QPA_PLATFORMTHEME = lib.mkForce "gtk3";
  # };

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
        import Quickshell.Wayland
        import Quickshell.Io
        import Quickshell.I3
        import QtQuick
        import QtQuick.Layouts
        PanelWindow {
              id: root

              property int cpuUsage: 0
              property int memUsage: 0

              property var lastCpuIdle: 0
              property var lastCpuTotal: 0
              // Theme (Overwritten from shell.qml)
              property color colBg: "${colors.base00}"
              property color colFg: "${colors.base05}"
              property color colMuted: "${colors.base03}"
              property color colCyan: "${colors.base0C}"
              property color colBlue: "${colors.base0D}"
              property color colYellow: "${colors.base0A}"
              property string fontFamily: "${fontFamily}"
              property int fontSize: ${toString fontSize}

              anchors.top: true
              anchors.left: true
              anchors.right: true
              implicitHeight: 30
              color: colBg

              RowLayout {
                  anchors.fill: parent
                  anchors.margins: 8

                  Repeater {
                      model: I3.workspaces

                      Text {
                          property bool isActive: modelData.focused
                          text: modelData.name
                          color: isActive ? colFg : colMuted
                          font {
                              pixelSize: 14
                              bold: true
                          }

                          MouseArea {
                              anchors.fill: parent
                              onClicked: I3.dispatch("workspace " + modelData.name)
                          }
                      }
                  }

                  Item {
                      Layout.fillWidth: true
                  }


                  // CPU
                  Text {
                      id: cpuText
                      text: "  " + cpuUsage + "%"
                      color: colFg
                      font.family: fontFamily
                      font.pixelSize: fontSize
                      font.bold: true
                  }

                  Rectangle {
                      width: 1
                      height: 16
                      color: colMuted
                  }

                  // Memory
                  Text {
                      id: memText
                      text: "  " + memUsage + "%"
                      color: colFg
                      font.family: fontFamily
                      font.pixelSize: fontSize
                      font.bold: true
                  }

                  Rectangle {
                      width: 1
                      height: 16
                      color: colMuted
                  }

                  // Clock
                  Text {
                      id: clock
                      color: colFg
                      font.family: fontFamily
                      font.pixelSize: fontSize
                      font.bold: true
                      text: Qt.formatDateTime(new Date(), "dd/MM/yyyy - HH:mm:ss")
                  }

                  // --- Processes ---
                  Process {
                      id: memProc
                      command: ["${pkgs.bash}/bin/sh", "-c", "free | grep Mem"]
                      stdout: SplitParser {
                          onRead: data => {
                              if (!data)
                                  return;
                              var parts = data.trim().split(/\s+/);
                              var total = parseInt(parts[1]) || 1;
                              var used = parseInt(parts[2]) || 0;
                              memUsage = Math.round(100 * used / total);
                          }
                      }
                      Component.onCompleted: running = true
                  }

                  Process {
                      id: cpuProc
                      command: ["${pkgs.bash}/bin/sh", "-c", "head -1 /proc/stat"]
                      stdout: SplitParser {
                          onRead: data => {
                              if (!data)
                                  return;
                              var p = data.trim().split(/\s+/);
                              var idle = parseInt(p[4]) + parseInt(p[5]);
                              var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                              if (lastCpuTotal > 0) {
                                  cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));
                              }
                              lastCpuTotal = total;
                              lastCpuIdle = idle;
                          }
                      }
                      Component.onCompleted: running = true
                  }

                  // --- Timer to update CPU/Memory ---
                  Timer {
                      interval: 2000
                      running: true
                      repeat: true
                      onTriggered: {
                          cpuProc.running = true;
                          memProc.running = true;
                      }
                  }

                  // --- Timer to update clock ---
                  Timer {
                      interval: 1000
                      running: true
                      repeat: true
                      onTriggered: clock.text = Qt.formatDateTime(new Date(), "dd/MM/yyyy - HH:mm:ss")
                  }

                  Item {
                      Layout.fillWidth: true
                  }

                  Text {
                      id: whoami
                      color: colFg
                      font {
                          family: root.fontFamily
                          pixelSize: root.fontSize
                          bold: true
                      }
                      text: "eragon@baruuk"

                      MouseArea {
                          anchors.fill: parent
                          onClicked: {
                              whoami.opacity = 0.5;
                              Quickshell.reload(true); // Reload full quickshell
                          }
                      }
                  }
              }
          }
      '';
  };
}
