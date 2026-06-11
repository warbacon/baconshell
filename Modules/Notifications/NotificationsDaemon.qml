import QtQuick

import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    NotificationServer {
        id: notificationServer
        imageSupported: true
        actionsSupported: true
        onNotification: notification => {
            notification.tracked = true;
        }
    }

    PanelWindow {
        visible: notificationServer.trackedNotifications.values.length > 0

        anchors {
            top: true
            right: true
        }

        exclusiveZone: 0
        color: "transparent"

        implicitWidth: 320 + 16
        implicitHeight: notificationsColumn.implicitHeight

        Column {
            id: notificationsColumn
            width: parent.width

            Repeater {
                model: notificationServer.trackedNotifications

                NotificationPopup {
                    required property var modelData
                    notification: modelData
                }
            }
        }
    }
}
