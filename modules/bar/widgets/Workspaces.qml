import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.style

WrapperRectangle {
    id: root
    property var bar
    color: Style.bg1

    radius: 6

    border.color: Style.border0
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
                readonly property bool isHovered: mouseArea.containsMouse

                radius: 4
                Layout.fillHeight: true
                visible: root.hyprlandReady && (modelData.monitor == Hyprland.monitorFor(bar.screen))
                leftMargin: 11
                rightMargin: 11

                color: isFocused ? Style.workspace_active_bg : isHovered ? Style.bg2 : "transparent"

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    color: parent.isFocused ? Style.bg1 : Style.fg0

                    text: parent.modelData.id
                    font.family: Style.fontFamily

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch(`focusworkspaceoncurrentmonitor ${modelData.id}`)
                    }
                }
            }
        }
    }
}
