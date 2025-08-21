import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import qs.modules.bar

ShellRoot {
    Variants {
        model: Quickshell.screens
        Scope {
            property var modelData

            Bar {
                screen: modelData
            }

            PanelWindow {
                id: window
                screen: modelData
                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: true
                }

                exclusionMode: ExclusionMode.Ignore
                WlrLayershell.layer: ExclusionMode.Ignore
                WlrLayershell.namespace: "shell:background"

                Image {
                    id: image
                    readonly property string path: Quickshell.env("XDG_CONFIG_HOME") + "/background"
                    source: path + "?" + Date.now()
                    anchors.fill: parent

                    FileView {
                        path: image.path
                        watchChanges: true
                        onFileChanged: () => {
                            image.source = image.path + "?" + Date.now();
                        }
                    }
                }
            }
        }
    }
}
