import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    property var bar
    color: "#1A1B26"
    border.color: "#232533"
    radius: 6

    property bool hyprlandReady: false

    Timer {
        id: hyprlandInitTimer
        interval: 1
        running: true
        repeat: false
        onTriggered: parent.hyprlandReady = true
    }

    implicitHeight: 28

    MarginWrapperManager {
        margin: 3
    }

    RowLayout {
        Repeater {
            model: Hyprland.workspaces
            Rectangle {
                required property HyprlandWorkspace modelData
                readonly property bool isFocused: modelData == Hyprland.focusedWorkspace

                radius: 4
                Layout.fillHeight: true
                visible: root.hyprlandReady && (modelData.monitor == Hyprland.monitorFor(bar.screen))

                MarginWrapperManager {
                    leftMargin: 11
                    rightMargin: 11
                    topMargin: 3
                    bottomMargin: 3
                }

                color: isFocused ? "#449dab" : "transparent"
                Text {
                    color: parent.isFocused ? "#1A1B26" : "#a9b1d6"
                    text: parent.modelData.id
                    font.family: bar.fontFamily
                }
            }
        }
    }
}
