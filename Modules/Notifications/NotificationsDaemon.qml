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

        margins {
            top: 8
            right: 8
        }

        exclusiveZone: 0
        color: "transparent"

        implicitWidth: 320
        implicitHeight: notificationsColumn.implicitHeight

        Column {
            id: notificationsColumn
            width: parent.width
            spacing: 8

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
