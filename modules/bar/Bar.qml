import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.bar.widgets

PanelWindow {
    id: bar

    property string fontFamily: "monospace"
    property int fontSize: 14
    property string position: "top"

    anchors {
        top: position == "top"
        bottom: position == "bottom"
        left: true
        right: true
    }

    implicitHeight: 36

    WrapperRectangle {
        anchors.fill: parent
        color: "#111118"

        rightMargin: 5
        leftMargin: 5

        RowLayout {
            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.fillHeight: true

                Workspaces {
                    bar: bar
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                Layout.fillHeight: true

                Sound {}
                Battery {}
                Time {}
            }
        }
    }

    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
            top: bar.position == "bottom" ? parent.top : undefined
            bottom: bar.position == "top" ? parent.bottom : undefined
        }
        height: 1
        color: "#232533"
    }
}
