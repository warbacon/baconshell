import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick

Scope {
    id: root

    property bool brightnessDimmed: false
    property int brightnessBeforeIdle: -1

    function currentBrightnessPercent() {
        const current = parseInt(currentBrightness.text());
        const max = parseInt(maxBrightness.text());

        if (isNaN(current) || isNaN(max) || max <= 0) {
            return -1;
        }

        return Math.round(current * 100 / max);
    }

    function dimBrightness() {
        if (root.brightnessDimmed) {
            return;
        }

        const currentPercent = root.currentBrightnessPercent();

        if (currentPercent < 10) {
            return;
        }

        root.brightnessBeforeIdle = currentPercent;
        brightnessctl.exec(["brightnessctl", "-q", "--save", "-d", "amdgpu_bl1", "set", "10%"]);
        root.brightnessDimmed = true;
    }

    function restoreBrightness() {
        if (!root.brightnessDimmed) {
            return;
        }

        brightnessctl.exec(["brightnessctl", "-q", "--restore", "-d", "amdgpu_bl1"]);
        root.brightnessDimmed = false;
        root.brightnessBeforeIdle = -1;
    }

    IdleMonitor {
        timeout: 60

        onIsIdleChanged: {
            if (isIdle) {
                root.dimBrightness();
            } else {
                root.restoreBrightness();
            }
        }
    }

    IdleMonitor {
        timeout: 300

        onIsIdleChanged: {
            if (isIdle) {
                suspendProcess.startDetached();
            }
        }
    }

    Process {
        id: brightnessctl
    }

    Process {
        id: suspendProcess
        command: ["systemctl", "suspend"]
    }

    FileView {
        id: currentBrightness
        watchChanges: true
        path: "/sys/class/backlight/amdgpu_bl1/brightness"
    }

    FileView {
        id: maxBrightness
        path: "/sys/class/backlight/amdgpu_bl1/max_brightness"
    }
}
