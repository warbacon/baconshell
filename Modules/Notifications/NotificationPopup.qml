import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.Notifications
import qs.Widgets
import qs.Commons

Item {
    id: root

    required property Notification notification

    readonly property int shadowPadding: 16
    readonly property int cardRadius: 10
    readonly property int cardPadding: 12
    readonly property int avatarSize: 64
    readonly property int borderWidth: 2

    readonly property bool isCritical: notification.urgency === NotificationUrgency.Critical
    readonly property bool hasImage: notification.image !== ""
    readonly property bool hasBody: notification.body !== ""
    readonly property bool hasActions: notification.actions.length > 0

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
        implicitHeight: content.implicitHeight + root.cardPadding * 2
        color: Color.mSurfaceHighest
        radius: root.cardRadius
        border.width: root.borderWidth
        border.color: root.isCritical ? Color.mError : Color.mPrimary

        MouseArea {
            anchors.fill: parent
            cursorShape: root.hasActions ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton

            onClicked: mouse => {
                if (mouse.button === Qt.MiddleButton) {
                    root.notification.dismiss();
                    return;
                }

                const defaultAction = root.notification.actions.find(a => a.identifier === "default");
                if (defaultAction)
                    defaultAction.invoke();
                else
                    root.notification.dismiss();
            }
        }

        RowLayout {
            id: content

            anchors.fill: parent
            anchors.margins: root.cardPadding
            spacing: 10

            Rectangle {
                visible: root.hasImage
                Layout.preferredWidth: root.avatarSize
                Layout.preferredHeight: root.avatarSize
                color: "transparent"

                Image {
                    anchors.fill: parent
                    source: root.hasImage ? root.notification.image : ""
                    fillMode: Image.PreserveAspectCrop
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                StyledText {
                    Layout.fillWidth: true
                    text: root.notification.summary
                    textFormat: Text.PlainText
                    font.pointSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                }

                StyledText {
                    Layout.fillWidth: true
                    visible: root.hasBody
                    text: root.notification.body
                    textFormat: Text.PlainText
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
