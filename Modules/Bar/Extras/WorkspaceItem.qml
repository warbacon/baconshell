import QtQuick
import Quickshell.Widgets
import qs.Commons
import qs.Components

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
        anchors.margins: 2
        radius: 6
        color: root.active ? Color.mPrimary : root.containsMouse ? Color.mSurfaceHighest : Color.mSurfaceHigh

        StyledText {
            id: label
            anchors.centerIn: parent
            color: root.active ? Color.mOnPrimary : Color.mOnSurface
            font.bold: root.active
        }
    }
}
