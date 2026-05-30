import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import qs.Modules.Notifications

PanelWindow {
    id: root

    // Panel settings
    anchors.top: true
    anchors.right: true
    margins.top: 50
    margins.right: 20

    implicitWidth: 380
    implicitHeight: notificationList.implicitHeight + 16

    color: "transparent"
    exclusiveZone: 0

    // Empty click mask to prevent blocking mouse events
    mask: Region {}

    // Notification server that listens to D-Bus
    NotificationServer {
        id: notificationServer
        
        keepOnReload: false
        
        // Capabilities
        bodySupported: true
        bodyMarkupSupported: false
        bodyHyperlinksSupported: false
        bodyImagesSupported: true
        imageSupported: true
        actionsSupported: true
        actionIconsSupported: false
        persistenceSupported: false
    }

    // Notification list model
    ListModel {
        id: notificationModel
    }

    // Map to track notification IDs
    property var notificationMap: ({})
    property int nextId: 0

    Connections {
        target: notificationServer

        function onNotification(notification) {
            notification.tracked = true

            const id = root.nextId++
            root.notificationMap[notification.id] = id

            notificationModel.append({
                "id": id,
                "notification": notification,
                "timestamp": Date.now()
            })

            console.log(
                `[Notification] ${notification.appName}: ${notification.summary}`
            )
        }
    }

    // Auto-remove dismissed notifications
    Connections {
        target: notificationServer.trackedNotifications

        function onTrackedNotificationsChanged() {
            // Clean up removed notifications
            for (let i = notificationModel.count - 1; i >= 0; --i) {
                const item = notificationModel.get(i)
                const stillExists = notificationServer.trackedNotifications.some(
                    n => n.id === item.notification.id
                )

                if (!stillExists) {
                    notificationModel.remove(i)
                }
            }
        }
    }

    // Scrollable list of notifications
    ScrollView {
        id: scrollArea
        anchors {
            fill: parent
            margins: 8
        }

        contentWidth: availableWidth

        ColumnLayout {
            id: notificationList
            width: scrollArea.availableWidth
            spacing: 12

            Repeater {
                model: notificationModel

                delegate: NotificationPopup {
                    Layout.fillWidth: true
                    notification: modelData.notification
                    index: index
                    totalCount: notificationModel.count

                    Component.onDestruction: {
                        if (notificationModel.count === 0) {
                            root.visible = false
                        }
                    }
                }
            }
        }
    }

    // Show/hide window based on notification count
    property bool hasNotifications: notificationModel.count > 0

    onHasNotificationsChanged: {
        if (hasNotifications) {
            visible = true
        } else {
            // Delay hiding to allow animations to finish
            hideTimer.restart()
        }
    }

    Timer {
        id: hideTimer
        interval: 300
        onTriggered: root.visible = false
    }

    Component.onCompleted: {
        console.log("[NotificationDaemon] Started")
    }
}
