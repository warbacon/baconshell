import QtQuick
import Quickshell.Io
import Quickshell

BarButton {
    id: brightness
    property real percentage: 0
    property string basePath: "/sys/class/backlight"
    property string device: "amdgpu_bl1"

    Process {
        id: brightnessUp
        command: ["brightnessctl", "set", "+10%"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: brightnessProc.running = true
        }
    }

    Process {
        id: brightnessDown
        command: ["brightnessctl", "set", "10%-"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: brightnessProc.running = true
        }
    }

    Process {
        id:maxBrightness
        command: ["brightnessctl", "max"]
        running: true
    }

    Process {
        id: brightnessProc
        command: ["brightnessctl", "get"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: brightness.percentage = this.text
        }
    }

    IpcHandler {
        target: "brightness"

        function up() {
            brightnessUp.running = true
        }

        function down() {
            brightnessDown.running = true
        }
    }

    icon: "☀️"
    text: `${percentage} %`
}
