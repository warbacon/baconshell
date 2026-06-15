import QtQuick
import QtQuick.Controls
import qs.Commons

Button {
    id: root
    property color bgColor: Color.mSurfaceHighest

    font.family: Style.fontFamily
    leftPadding: 20
    rightPadding: 20
    topPadding: 8
    bottomPadding: 8

    background: Rectangle {
        radius: 8
        color: root.down ? Qt.darker(root.bgColor, 1.2) : root.bgColor
    }

    contentItem: Text {
        text: root.text
        color: root.bgColor == Color.mPrimary ? Color.mOnPrimary : Color.mOnSurface
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: Style.fontFamily
    }
}
