pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string backlightDevice: ""
    property bool available: false

    function backlightPath(name) {
        return root.backlightDevice === "" ? "" : `/sys/class/backlight/${root.backlightDevice}/${name}`;
    }

    function updateAvailability() {
        root.available = root.backlightDevice !== "";
    }

    function setBacklightDevice(device) {
        root.backlightDevice = device;
        root.updateAvailability();
    }

    function parseBacklightDevice(output) {
        const lines = output.split("\n").filter(line => line !== "");

        return lines.length > 0 ? lines[0].split("/").pop() : "";
    }

    readonly property int currentBrightness: {
        const current = parseInt(currentBrightnessFile.text());
        const max = parseInt(maxBrightnessFile.text());

        if (isNaN(current) || isNaN(max) || max <= 0) {
            return -1;
        }

        return Math.round(current * 100 / max);
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
                root.setBacklightDevice(root.parseBacklightDevice(text));
            }
        }
    }

    FileView {
        id: maxBrightnessFile
        path: root.backlightPath("max_brightness")
        onLoadFailed: root.available = false
    }

    FileView {
        id: currentBrightnessFile
        watchChanges: true
        path: root.backlightPath("brightness")
        onFileChanged: this.reload()
        onLoadFailed: root.available = false
    }
}
