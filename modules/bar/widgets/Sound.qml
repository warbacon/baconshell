import Quickshell.Services.Pipewire
import Quickshell.Io
import QtQuick
import qs.style

BarButton {
    property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    iconColor: sink.audio.muted ? Style.fg0 : Style.accent
    icon: sink.audio.muted ? "󰝟" : "󰕾"
    text: sink.audio.muted ? "" : Math.round(sink.audio.volume * 100) + " %"

    Process {
        id: command
        command: ["kitty", "-1", "pulsemixer"]
    }

    onClicked: mouse => {
        if (mouse.button == Qt.LeftButton) {
            sink.audio.muted = !sink.audio.muted;
        }
        if (mouse.button == Qt.RightButton) {
            command.startDetached();
        }
    }
}
