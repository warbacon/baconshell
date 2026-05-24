import QtQuick
import Quickshell.Widgets
import qs.Commons

WrapperMouseArea {
    id: root
    property alias text: text.text
    property bool isActive: false

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Rectangle {
        radius: 99
        color: root.isActive ? Color.mPrimary : root.containsMouse ? Color.mSurfaceHighest : Color.mSurfaceHigh
        anchors.fill: parent

        Text {
            id: text
            color: root.isActive ? Color.mOnPrimary : Color.mOnSurface
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: Style.fontFamily
            font.pointSize: Style.fontSize
        }
    }
}
