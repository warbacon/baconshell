pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string backlightDevice: ""
    property bool available: false

    readonly property int currentBrightness: {
        const current = parseInt(currentBrightnessFile.text());
        const max = parseInt(maxBrightnessFile.text());

        if (isNaN(current) || isNaN(max) || max <= 0) {
            return -1;
        }

        return Math.round(current * 100 / max);
    }

    function refreshAvailability() {
        root.available = root.backlightDevice !== "";
    }

    function currentBrightnessPercent() {
        return root.currentBrightness;
    }

    function setBrightness(step, direction) {
        if (!root.available) {
            return;
        }

        brightnessctl.exec(["brightnessctl", "-e4", "-n2", "set", `${step}%${direction}`]);
    }

    Process {
        id: brightnessctl
    }

    Process {
        id: backlightFinder
        running: true
        command: ["sh", "-c", "printf '%s\n' /sys/class/backlight/*"]

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n").filter(line => line !== "");

                if (lines.length > 0) {
                    root.backlightDevice = lines[0].split("/").pop();
                } else {
                    root.backlightDevice = "";
                }

                root.refreshAvailability();
            }
        }
    }

    FileView {
        id: maxBrightnessFile
        path: root.backlightDevice === "" ? "" : `/sys/class/backlight/${root.backlightDevice}/max_brightness`
        onLoadFailed: root.available = false
    }

    FileView {
        id: currentBrightnessFile
        watchChanges: true
        path: root.backlightDevice === "" ? "" : `/sys/class/backlight/${root.backlightDevice}/brightness`
        onFileChanged: this.reload()
        onLoadFailed: root.available = false
    }
}
