import Quickshell.Io
import Quickshell.Wayland
import Quickshell
import QtQuick

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "shell:background"
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    FileView {
        path: image.path
        watchChanges: true
        onFileChanged: () => {
            image.source = image.path + "?" + Date.now();
        }
    }

    Image {
        id: image

        readonly property string path: Quickshell.env("HOME") + "/.config/background"

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        source: path + "?" + Date.now()
        sourceSize.width: root.screen.width
        sourceSize.height: root.screen.height

        asynchronous: true
        cache: false
    }
}
