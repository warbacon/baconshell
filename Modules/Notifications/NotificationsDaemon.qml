import QtQuick

import Quickshell
import QtQuick.Layouts
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
        id: window
        visible: notificationServer.trackedNotifications.values.length > 0

        anchors {
            top: true
            right: true
        }

        color: "transparent"

        implicitWidth: 350
        implicitHeight: notificationsColumn.implicitHeight

        ColumnLayout {
            id: notificationsColumn
            width: parent.width
            spacing: 0

            Repeater {
                model: notificationServer.trackedNotifications.values.slice().reverse()

                NotificationPopup {
                    required property var modelData
                    notification: modelData
                    Layout.fillWidth: true
                }
            }
        }
    }
}
