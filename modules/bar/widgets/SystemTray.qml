import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Rectangle {
    color: "#1a1b26"
    radius: 6
    border.color: "#232533"

    visible: workspaces.count > 0
    implicitWidth: layout.implicitWidth + 24
    implicitHeight: layout.implicitHeight + 12

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 5

        Repeater {
            id: workspaces
            model: SystemTray.items

            IconImage {
                id: trayRoot
                required property SystemTrayItem modelData

                source: modelData.icon
                Layout.alignment: Qt.AlignCenter
                implicitSize: 16

                MouseArea {
                    anchors.fill: parent

                    cursorShape: Qt.PointingHandCursor

                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton)
                            trayRoot.modelData.activate();
                    }

                }
            }
        }
    }
}
