import Quickshell.Services.UPower
import QtQuick

BarButton {
    readonly property UPowerDevice battery: UPower.displayDevice
    hidden: !battery.isLaptopBattery
    text: Math.round(battery.percentage * 100) + " %"
    icon: {
        if(battery.state == UPowerDeviceState.Charging) {
            return "󰂄"
        }
        return text < 20 ? "󰁻" : "󰂀"
    }
}
