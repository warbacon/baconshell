import Quickshell.Io
import Quickshell.Wayland
import Quickshell
import QtQuick

PanelWindow {
    id: root
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "shell:background"

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    color: "transparent"

    Image {
        id: image
        readonly property string path: Quickshell.env("HOME") + "/.config/background"
        source: path + "?" + Date.now()
        sourceSize.width: root.screen.width
        sourceSize.height: root.screen.height
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false

        FileView {
            path: image.path
            watchChanges: true
            onFileChanged: () => {
                image.source = image.path + "?" + Date.now();
            }
        }
    }
}
