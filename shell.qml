//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.Modules
import qs.Modules.Bar
import qs.Modules.Notifications

ShellRoot {
    id: shellRoot

    // Notification daemon
    NotificationDaemon {
        id: notificationDaemon
    }

    Variants {
        model: Quickshell.screens

        delegate: Item {
            required property ShellScreen modelData

            Bar {
                screen: modelData
                border: true
            }

            Background {
                screen: modelData
            }
        }
    }
}
