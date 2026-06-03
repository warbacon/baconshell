import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.Services as Services
import Quickshell.Io

Scope {
    id: root

    property bool brightnessDimmed: false

    function dimBrightness() {
        if (root.brightnessDimmed) {
            return;
        }

        const currentPercent = Services.Brightness.currentBrightnessPercent();

        if (currentPercent <= 10) {
            return;
        }

        brightnessctl.exec(["brightnessctl", "-q", "--save", "set", "10%", "--device", Services.Brightness.backlightDevice]);
        root.brightnessDimmed = true;
    }

    function restoreBrightness() {
        if (!root.brightnessDimmed) {
            return;
        }

        brightnessctl.exec(["brightnessctl", "-q", "--restore", "--device", Services.Brightness.backlightDevice]);
        root.brightnessDimmed = false;
    }

    IdleMonitor {
        timeout: 60
        enabled: Services.Brightness.available

        onIsIdleChanged: {
            if (isIdle) {
                root.dimBrightness();
            } else {
                root.restoreBrightness();
            }
        }
    }

    IdleMonitor {
        timeout: 90

        onIsIdleChanged: {
            if (isIdle) {
                powerOffMonitorsProcess.startDetached();
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
        id: suspendProcess
        command: ["systemctl", "suspend"]
    }

    Process {
        id: powerOffMonitorsProcess
        command: ["niri", "msg", "action", "power-off-monitors"]
    }

    Process {
        id: brightnessctl
    }
}
