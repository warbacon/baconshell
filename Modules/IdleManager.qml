import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.Services as Services
import Quickshell.Io

Scope {
    id: root

    property bool brightnessDimmed: false
    property bool caffeineMode: false
    onCaffeineModeChanged: {
        console.log(`Caffeine Mode: ${root.caffeineMode ? "on" : "off"}`);
        caffeineNotification.exec(["notify-send", "Modo cafeína", `${root.caffeineMode ? "Activado" : "Desactivado"}`]);
    }

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

    Process {
        id: caffeineNotification
    }

    IpcHandler {
        target: "caffeine"

        function toggle() {
            root.caffeineMode = !root.caffeineMode;
        }
    }

    IdleMonitor {
        timeout: 60
        enabled: Services.Brightness.available && !root.caffeineMode

        onIsIdleChanged: {
            if (isIdle) {
                root.dimBrightness();
            } else {
                root.restoreBrightness();
            }
        }
    }

    IdleMonitor {
        enabled: !root.caffeineMode
        timeout: 90

        onIsIdleChanged: {
            if (isIdle) {
                powerOffMonitorsProcess.startDetached();
            }
        }
    }

    IdleMonitor {
        enabled: !root.caffeineMode
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
