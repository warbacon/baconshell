import QtQuick
import Quickshell.Widgets
import qs.Commons

WrapperMouseArea {
    id: root

    property bool active: false
    property alias text: label.text

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    implicitHeight: 25
    implicitWidth: label.implicitWidth + 20

    Rectangle {
        id: rect

        anchors.fill: parent
        radius: 8
        color: root.active ? Color.mPrimary : root.containsMouse ? Color.mSurfaceHighest : Color.mSurfaceHigh

        Text {
            id: label

            anchors.centerIn: parent
            color: root.active ? Color.mOnPrimary : Color.mOnSurface
            font.bold: root.active
            font.family: Style.fontFamily
            font.pointSize: Style.fontSize
        }
    }
}
