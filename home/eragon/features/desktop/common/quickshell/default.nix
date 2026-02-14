{ config, ... }:
with config.lib.stylix.colors.withHashtag;
let
  fontSize = toString config.stylix.fonts.sizes.desktop;
in
{
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."quickshell/shell.qml".text =
    let
      # Pull all stylix colors and fonts
      fontFamily = config.lib.stylix.font.family;
      fontSize = config.lib.stylix.font.size;
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

          // Theme
        property color colBg: "${base00}"
        property color colFg: "${base05}"
        property color colMuted: "${base03}"
        property color colCyan: "${base0C}"
        property color colBlue: "${base0D}"
        property color colYellow: "${base0A}"
        property string fontFamily: "${fontFamily}"
        property int fontSize: ${toString fontSize}

          // System data
          property int cpuUsage: 0
          property int memUsage: 0
          property var lastCpuIdle: 0
          property var lastCpuTotal: 0

          // Processes
          Process {
              id: whoamiProc
              command: ["sh", "-c", "echo $USER@$HOST"]
              Component.onCompleted: running = false

          }

          Process {
              id: memProc
              command: ["sh", "-c", "free | grep Mem"]
              stdout: SplitParser {
                  onRead: data => {
                      if (!data) return
                      var parts = data.trim().split(/\s+/)
                      var total = parseInt(parts[1]) || 1
                      var used = parseInt(parts[2]) || 0
                      memUsage = Math.round(100 * used / total)
                  }
              }
              Component.onCompleted: running = true
          }

          Process {
              id: cpuProc
              command: ["sh", "-c", "head -1 /proc/stat"]
              stdout: SplitParser {
                  onRead: data => {
                      if (!data) return
                      var p = data.trim().split(/\s+/)
                      var idle = parseInt(p[4]) + parseInt(p[5])
                      var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                      if (lastCpuTotal > 0) {
                          cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
                      }
                      lastCpuTotal = total
                      lastCpuIdle = idle
                  }
              }
              Component.onCompleted: running = true
          }

          // Timers
          Timer {
              interval: 2000
              running: true
              repeat: true
              onTriggered: {
                  cpuProc.running = true
                  memProc.running = true
              }
          }

          anchors.top: true
          anchors.left: true
          anchors.right: true
          implicitHeight: 30
          color: root.colBg

          RowLayout {
              anchors.fill: parent
              anchors.margins: 8

              // Workspaces
              Repeater {
                  model: I3.workspaces

                  Text {
                      property bool isActive: modelData.focused
                      text: modelData.name
                      color: isActive ? "${base0C}" : (modelData.visible ? "${base0D}" : "${base03}")
                      font { pixelSize: 14; bold: true }

                      MouseArea {
                          anchors.fill: parent
                          onClicked: I3.dispatch("workspace " + modelData.name)
                      }
                  }
              }

              Item { Layout.fillWidth: true }

              // CPU
              Text {
                  text: "  " + cpuUsage + "%"
                  color: root.colYellow
                  font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
              }

              Rectangle { width: 1; height: 16; color: root.colMuted }

              // Memory
              Text {
                  text: "  " + memUsage + "%"
                  color: root.colCyan
                  font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
              }

              Rectangle { width: 1; height: 16; color: root.colMuted }

              // Clock
              Text {
                  id: clock
                  color: root.colBlue
                  font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                  text: Qt.formatDateTime(new Date(), "dd/MM/yyyy - HH:mm:ss")
                  Timer {
                      interval: 1000
                      running: true
                      repeat: true
                      onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                  }
              }
              Item { Layout.fillWidth: true }

              Text {
                  id: whoami
                  color: root.colBlue
                  font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
                  text: "eragon@baruuk"

                  MouseArea {
                      anchors.fill: parent
                      onClicked: {
                          whoami.opacity = 0.5
                          Quickshell.reload(true) // Reload full quickshell
                      }
                  }
              }
          }
      }


    '';
}
