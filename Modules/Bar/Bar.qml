import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick
import qs.Commons
import qs.Modules.Bar.Widgets

PanelWindow {
    id: bar
    property alias border: border.visible

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 34
    color: "transparent"

    // Content
    WrapperRectangle {
        anchors.fill: parent
        color: Color.mSurface

        leftMargin: 3
        rightMargin: 3

        RowLayout {
            RowLayout {
                Workspaces {
                    screen: bar.screen
                }
                WindowTitle {}
            }
            RowLayout {
                Layout.alignment: Qt.AlignRight
                SystemTray {}
                Sound {}
                Brightness {}
                Battery {}
                Network {}
                Clock {}
            }
        }
    }

    // Outline
    Rectangle {
        id: border
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        height: 1
        color: Color.mOutline
    }
}
