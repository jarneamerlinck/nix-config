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
        id: sessionStatus
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

        Text {
            id: whoami
            color: root.colBlue
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


  '';
}
