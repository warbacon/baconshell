//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.Modules
import qs.Modules.Bar

ShellRoot {
    id: shellRoot

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
