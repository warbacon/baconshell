import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    required property string text
    property bool clickable: true
    property string icon: ""
    property bool hidden: false

    visible: !hidden

    color: mouseArea.pressed ? "#2c2e3e" : mouseArea.containsMouse ? "#1f202c" : "#1a1b26"

    radius: 6
    border.color: "#232533"
    border.width: 1

    implicitWidth: (textObj.visible ? textObj.implicitWidth : 0) + (iconObj.visible ? iconObj.implicitWidth : 0) + 32
    implicitHeight: textObj.implicitHeight + 12

    signal clicked

    RowLayout {
        spacing: 0
        anchors {
            fill: parent
            leftMargin: 16
            rightMargin: 16
        }

        Text {
            id: iconObj
            visible: root.icon != ""
            text: root.icon
            font.pixelSize: 14
            font.family: "Symbols Nerd Font"
            color: "#449dab"
        }

        Text {
            id: textObj
            visible: root.text != ""
            font.family: "monospace"
            font.pixelSize: 14
            color: "#a9b1d6"
            text: (iconObj.visible ? " " : "") + root.text
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.clickable
        hoverEnabled: true
        onClicked: root.clicked()
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}
