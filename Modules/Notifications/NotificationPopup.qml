import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Notifications
import qs.Commons

Item {
    id: root
    property Notification notification

    readonly property int shadowPadding: 16

    implicitWidth: 320 + shadowPadding
    implicitHeight: card.implicitHeight + shadowPadding

    Timer {
        interval: Math.abs(root.notification.expireTimeout)
        running: root.notification.expireTimeout > 0
        onTriggered: root.notification.expire()
    }

    RectangularShadow {
        anchors.fill: card
        radius: card.radius
        blur: 6
        spread: 0
        offset.y: 2
        color: Qt.rgba(0, 0, 0, 0.5)
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: root.width - root.shadowPadding
        implicitHeight: content.implicitHeight + 24
        color: Color.mSurfaceHighest
        radius: 10
        border {
            width: 2
            color: root.notification.urgency == NotificationUrgency.Critical ? Color.mError : Color.mPrimary
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: root.notification.actions.length > 0 && Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            function invokeDefaultAction() {
                if (!root.notification)
                    return;
                for (let i = 0; i < root.notification.actions.length; ++i) {
                    const action = root.notification.actions[i];
                    if (action.identifier === "default") {
                        action.invoke();
                        return;
                    }
                }
                root.notification.dismiss();
            }
            onClicked: function (mouse) {
                if (!root.notification)
                    return;
                if (mouse.button === Qt.MiddleButton) {
                    root.notification.dismiss();
                    return;
                }
                invokeDefaultAction();
            }
        }

        RowLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            Rectangle {
                visible: root.notification.image
                implicitWidth: 64
                implicitHeight: 64
                color: "transparent"

                Image {
                    anchors.fill: parent
                    source: root.notification.image
                    fillMode: Image.PreserveAspectCrop
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: root.notification ? root.notification.summary : ""
                    textFormat: Text.PlainText
                    color: Color.mOnSurface
                    font.family: Style.fontFamily
                    font.pointSize: 11
                    font.bold: true
                    elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true
                    visible: root.notification && root.notification.body !== ""
                    text: root.notification ? root.notification.body : ""
                    font.family: Style.fontFamily
                    font.pointSize: 10
                    textFormat: Text.PlainText
                    color: Color.mOnSurface
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
