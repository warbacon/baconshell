import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Components

WrapperMouseArea {
    id: root

    property bool clickable: false
    property bool hasImage: icon.startsWith("image://")
    property string icon: ""
    property alias iconColor: iconText.color
    property alias text: labelText.text
    property alias textColor: labelText.color
    property alias bgColor: rect.color

    default property alias content: layout.data

    hoverEnabled: clickable
    cursorShape: clickable ? Qt.PointingHandCursor : Qt.ArrowCursor

    WrapperRectangle {
        id: rect

        color: root.containsMouse && root.clickable ? Color.mSurfaceHighest : Color.mSurfaceHigh
        radius: 8

        implicitHeight: 25
        rightMargin: 10
        leftMargin: 10

        RowLayout {
            id: layout
            spacing: 8

            Loader {
                active: root.hasImage
                visible: root.hasImage
                sourceComponent: IconImage {
                    source: root.icon
                    implicitSize: 16
                }
            }

            StyledText {
                id: iconText
                visible: root.icon != "" && !root.hasImage
                text: root.icon
                color: Color.mPrimary
                font.family: "Symbols Nerd Font"
            }

            StyledText {
                id: labelText
                visible: text != ""
            }
        }
    }
}
