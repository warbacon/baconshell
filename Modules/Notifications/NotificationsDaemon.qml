import QtQuick

import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root

    property var notifications: []

    function addNotification(notification) {
        notifications = [notification].concat(notifications);
    }

    function removeNotification(notification) {
        notifications = notifications.filter(function (item) {
            return item !== notification;
        });
    }

    NotificationServer {
        onNotification: {
            notification.tracked = true;
            root.addNotification(notification);
        }
    }

    PanelWindow {
        visible: root.notifications.length > 0

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
                model: root.notifications

                NotificationPopup {
                    required property var modelData
                    notification: modelData

                    onDismissed: root.removeNotification(notification)
                }
            }
        }
    }
}
