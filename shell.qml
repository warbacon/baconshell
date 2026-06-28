//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.Modules
import qs.Modules.Bar
import qs.Modules.Notifications

ShellRoot {
    NotificationsDaemon {}
    IdleManager {}
    Polkit {}
    // VolumeOSD {}

    Variants {
        model: Quickshell.screens

        Scope {
            id: scope
            required property ShellScreen modelData

            Bar {
                screen: scope.modelData
            }

            Background {
                screen: scope.modelData
            }
        }
    }
}
