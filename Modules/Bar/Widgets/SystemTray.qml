import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import qs.Modules.Bar.Extras

Pill {
    id: pill
    visible: SystemTray.items.values.length > 0
    spacing: 14

    Repeater {
        model: SystemTray.items
        delegate: IconImage {
            id: icon
            required property SystemTrayItem modelData
            source: modelData.icon
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16

            QsMenuAnchor {
                id: menu
                anchor.item: icon
                anchor.margins.top: 20
                menu: icon.modelData.menu
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button == Qt.LeftButton) {
                        if (icon.modelData.onlyMenu) {
                            menu.open();
                        } else {
                            icon.modelData.activate();
                        }
                    }

                    if (mouse.button == Qt.RightButton && icon.modelData.hasMenu) {
                        menu.open();
                    }
                }
            }
        }
    }
}
