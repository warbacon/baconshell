import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.style

WrapperRectangle {
    id: root
    required property string text
    property bool clickable: true
    property string iconColor: Style.accent
    property string icon: ""
    property bool hidden: false

    visible: !hidden

    color: mouseArea.pressed ? "#2c2e3e" : mouseArea.containsMouse ? "#1f202c" : Style.bg1

    radius: 6
    border.color: Style.border0
    border.width: 1

    implicitHeight: 28

    signal clicked(var mouse)

    WrapperMouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.clickable
        hoverEnabled: true
        onClicked: root.clicked(mouse)
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.RightButton | Qt.LeftButton

        leftMargin: 14
        rightMargin: 14

        RowLayout {
            spacing: 0

            Text {
                id: iconObj
                visible: root.icon != ""
                text: root.icon
                font.pixelSize: 14
                font.family: "Symbols Nerd Font"
                color: root.iconColor
            }

            Text {
                id: textObj
                visible: root.text != ""
                font.family: Style.fontFamily
                font.pixelSize: 14
                color: Style.fg1
                text: (iconObj.visible ? " " : "") + root.text
            }
        }
    }
}
