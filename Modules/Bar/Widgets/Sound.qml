import Quickshell.Services.Pipewire
import QtQuick
import Quickshell.Io
import qs.Modules.Bar.Extras
import qs.Commons

Pill {
    property var sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    visible: Pipewire.ready

    iconColor: sink.audio.muted ? Color.mOnSurfaceVariant : Color.mPrimary

    icon: {
        const props = sink.properties;
        const isHeadphones = props["device.form-factor"] === "headset";

        if (sink.audio.muted)
            return isHeadphones ? "󰟎" : "󰝟";

        const vol = sink.audio.volume;

        if (isHeadphones)
            return "󰋋";
        if (vol >= 0.7)
            return "󰕾";
        if (vol >= 0.3)
            return "󰖀";
        return "󰕿";
    }

    text: sink.audio.muted ? "" : `${Math.round(sink.audio.volume * 100)} %`

    clickable: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    onWheel: wheel => {
        const delta = wheel.angleDelta.y > 0 ? 0.01 : -0.01;
        const newVolume = Math.max(0, Math.min(1, sink.audio.volume + delta));

        sink.audio.muted = false;
        sink.audio.volume = newVolume;
    }

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            sink.audio.muted = !sink.audio.muted;
        } else if (mouse.button === Qt.RightButton) {
            pulsemixer.running = !pulsemixer.running;
        }
    }

    Process {
        id: pulsemixer
        command: ["xdg-terminal-exec", "pulsemixer"]
    }
}
