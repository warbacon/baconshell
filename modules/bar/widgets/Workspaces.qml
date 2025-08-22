import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

WrapperRectangle {
    id: root
    property var bar
    color: "#1A1B26"

    radius: 6

    border.color: "#232533"
    border.width: 1

    property bool hyprlandReady: false

    Timer {
        id: hyprlandInitTimer
        interval: 1
        running: true
        repeat: false
        onTriggered: parent.hyprlandReady = true
    }

    implicitHeight: 28

    margin: 2

    RowLayout {
        Repeater {
            model: Hyprland.workspaces
            WrapperRectangle {
                required property HyprlandWorkspace modelData
                readonly property bool isFocused: modelData == Hyprland.focusedWorkspace

                radius: 4
                Layout.fillHeight: true
                visible: root.hyprlandReady && (modelData.monitor == Hyprland.monitorFor(bar.screen))

                leftMargin: 10
                rightMargin: 10

                color: isFocused ? "#449dab" : "transparent"

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: parent.isFocused ? "#1A1B26" : "#a9b1d6"
                    text: parent.modelData.id
                    font.family: bar.fontFamily
                }
            }
        }
    }
}
