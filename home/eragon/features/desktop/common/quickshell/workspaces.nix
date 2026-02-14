{ config, ... }:
{

  xdg.configFile."quickshell/Workspaces.qml".text = ''
    import Quickshell
    import Quickshell.Wayland
    import Quickshell.Io
    import Quickshell.I3
    import QtQuick
    import QtQuick.Layouts

    RowLayout {
        id: workspaces

        // Theme (Overwritten from shell.qml)
        property color colBg: "#251724"
        property color colFg: "#dbe3f0"
        property color colMuted: "#969fa8"
        property color colCyan: "#89919c"
        property color colBlue: "#88929c"
        property color colYellow: "#8b919d"
        property string fontFamily: "FiraCode Nerd Font Sans"
        property int fontSize: 14

        Repeater {
            model: I3.workspaces

            Text {
                property bool isActive: modelData.focused
                text: modelData.name
                color: isActive ? "#89919c" : (modelData.visible ? "#88929c" : "#969fa8")
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
    }
  '';
}
