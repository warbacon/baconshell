import QtQuick
import qs.Services as Services
import qs.Modules.Bar.Extras

Pill {
    id: root

    property int brightnessLevel: {
        return Services.Brightness.currentBrightness < 0 ? 0 : Services.Brightness.currentBrightness;
    }

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

    onWheel: wheel => {
        if (wheel.angleDelta.y > 0) {
            Services.Brightness.setBrightness(4, "+");
        } else {
            Services.Brightness.setBrightness(4, "-");
        }
    }

    scrollGestureEnabled: true

    visible: Services.Brightness.available
}
