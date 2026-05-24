import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Io
import qs.Modules.Bar.Extras
import qs.Commons

Pill {
    id: root
    property bool menuOpened: false

    icon: ""
    clickable: true
    onClicked: {
        if (!menu.loading) {
            menu.loading = true;
        }

        menuOpened = !menuOpened;

        console.log(menuOpened);
    }

    LazyLoader {
        id: menu
        loading: false

        PanelWindow {
            visible: root.menuOpened

            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.menuOpened = false;
                }
            }

            Rectangle {
                implicitWidth: 300
                implicitHeight: 80
                color: Color.mSurface
                // radius: 16
                bottomRightRadius: 16

                // border.width: 1
                // border.color: Color.mOutline

                MouseArea {
                    anchors.fill: parent
                    onClicked: {}
                }

                GridLayout {
                    columns: 2
                    anchors.fill: parent
                    anchors.margins: 18
                    columnSpacing: 10

                    MenuToggle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 44

                        text: "Luz nocturna"
                        isActive: sunsetrProcess.running

                        onClicked: {
                            sunsetrProcess.running = !sunsetrProcess.running;
                        }

                        Process {
                            id: sunsetrProcess
                            command: ["sunsetr"]
                        }
                    }
                }
            }
        }
    }
}
