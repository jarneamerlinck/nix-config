{ config, ... }:
{

  xdg.configFile."quickshell/SystemStatus.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io
    import Quickshell.I3
    import QtQuick
    import QtQuick.Layouts

    RowLayout {
        id: systemStatus
        property int cpuUsage: 0
        property int memUsage: 0

        property var lastCpuIdle: 0
        property var lastCpuTotal: 0

        // Theme (Overwritten from shell.qml)
        property color colBg: "#251724"
        property color colFg: "#dbe3f0"
        property color colMuted: "#969fa8"
        property color colCyan: "#89919c"
        property color colBlue: "#88929c"
        property color colYellow: "#8b919d"
        property string fontFamily: "FiraCode Nerd Font Sans"
        property int fontSize: 14

        // CPU
        Text {
            id: cpuText
            text: "  " + cpuUsage + "%"
            color: systemStatus.colYellow
            font.family: systemStatus.fontFamily
            font.pixelSize: systemStatus.fontSize
            font.bold: true
        }

        Rectangle {
            width: 1
            height: 16
            color: "#969fa8"
        }

        // Memory
        Text {
            id: memText
            text: "  " + memUsage + "%"
            color: systemStatus.colCyan
            font.family: systemStatus.fontFamily
            font.pixelSize: systemStatus.fontSize
            font.bold: true
        }

        Rectangle {
            width: 1
            height: 16
            color: "#969fa8"
        }

        // Clock
        Text {
            id: clock
            color: systemStatus.colBlue
            font.family: systemStatus.fontFamily
            font.pixelSize: systemStatus.fontSize
            font.bold: true
            text: Qt.formatDateTime(new Date(), "dd/MM/yyyy - HH:mm:ss")
        }

        // --- Processes ---
        Process {
            id: memProc
            command: ["sh", "-c", "free | grep Mem"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data)
                        return;
                    var parts = data.trim().split(/\s+/);
                    var total = parseInt(parts[1]) || 1;
                    var used = parseInt(parts[2]) || 0;
                    systemStatus.memUsage = Math.round(100 * used / total);
                }
            }
            Component.onCompleted: running = true
        }

        Process {
            id: cpuProc
            command: ["sh", "-c", "head -1 /proc/stat"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data)
                        return;
                    var p = data.trim().split(/\s+/);
                    var idle = parseInt(p[4]) + parseInt(p[5]);
                    var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                    if (lastCpuTotal > 0) {
                        systemStatus.cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)));
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
    }
  '';
}
