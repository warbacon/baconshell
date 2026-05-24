import QtQuick
import Quickshell.Io
import qs.Modules.Bar.Extras

Pill {
    id: root

    property int brightnessLevel: Math.round(currentBrightness.text() * 100 / maxBrightness.text())

    icon: {
        if (brightnessLevel > 50) {
            "󰃠";
        } else if (brightnessLevel > 10) {
            "󰃟";
        } else {
            "󰃞";
        }
    }

    text: `${brightnessLevel} %`

    Process {
        id: brightnessctl
    }

    onWheel: wheel => {
        const step = 4;

        if (wheel.angleDelta.y > 0) {
            brightnessctl.exec(["brightnessctl", "-e4", "-n2", "set", `${step}%+`]);
        } else {
            brightnessctl.exec(["brightnessctl", "-e4", "-n2", "set", `${step}%-`]);
        }
    }

    scrollGestureEnabled: true

    FileView {
        id: maxBrightness
        path: "/sys/class/backlight/amdgpu_bl1/max_brightness"
        onLoadFailed: root.visible = false
    }

    FileView {
        id: currentBrightness
        watchChanges: true
        path: "/sys/class/backlight/amdgpu_bl1/brightness"
        onFileChanged: this.reload()
        onLoadFailed: root.visible = false
    }
}
