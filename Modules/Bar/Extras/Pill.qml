import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.Commons

WrapperMouseArea {
    id: root

    property bool clickable: false
    property string icon: ""
    property alias iconColor: iconText.color
    property alias text: labelText.text
    property alias textColor: labelText.color
    property alias bgColor: rect.color
    property alias spacing: layout.spacing

    default property alias content: layout.data

    hoverEnabled: clickable
    cursorShape: clickable ? Qt.PointingHandCursor : Qt.ArrowCursor

    WrapperRectangle {
        id: rect

        color: root.containsMouse && root.clickable ? Color.mSurfaceHighest : Color.mSurfaceHigh
        radius: 99

        border {
            width: 1
            color: Color.mOutline
        }

        implicitHeight: 25
        rightMargin: 10
        leftMargin: 10

        RowLayout {
            id: layout
            spacing: 7

            Loader {
                id: imageLoader
                visible: root.icon.startsWith("image://")
                active: root.icon.startsWith("image://")
                sourceComponent: IconImage {
                    source: root.icon
                    implicitSize: 16
                }
            }

            Text {
                id: iconText
                visible: root.icon != "" && !root.icon.startsWith("image://")
                text: root.icon
                color: Color.mPrimary
                font.family: "Symbols Nerd Font"
                font.pointSize: Style.fontSize
            }

            Text {
                id: labelText
                visible: text != ""
                color: Color.mOnSurface
                font.family: Style.fontFamily
                font.pointSize: Style.fontSize
            }
        }
    }
}
