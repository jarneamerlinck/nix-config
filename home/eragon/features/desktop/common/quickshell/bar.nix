{ config, ... }:
{

  xdg.configFile."quickshell/Bar.qml".text = ''
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
}
