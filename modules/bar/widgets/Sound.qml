import Quickshell.Services.Pipewire

BarButton {
    property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
        onObjectsChanged: {
            sink = Pipewire.defaultAudioSink;
        }
    }

    onClicked: sink.audio.muted = !sink.audio.muted

    icon: sink.audio.muted ? "󰝟" : "󰕾"
    text: sink.audio.muted ? "" : Math.round(sink.audio.volume * 100) + " %"
}
