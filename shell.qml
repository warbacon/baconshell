//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.Modules
import qs.Modules.Bar
import qs.Modules.Notifications

ShellRoot {
    id: shellRoot

    NotificationsDaemon {}

    IdleManager {}

    Variants {
        model: Quickshell.screens

        delegate: Item {
            required property ShellScreen modelData

            Bar {
                screen: modelData
                border: false
            }

            Background {
                screen: modelData
            }
        }
    }
}
