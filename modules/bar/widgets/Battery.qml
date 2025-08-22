import Quickshell.Services.UPower
import qs.style
import QtQuick

BarButton {
    readonly property UPowerDevice battery: UPower.displayDevice

    // Helpers
    readonly property int percent: Math.round(battery.percentage * 100)
    readonly property bool charging: battery.state == UPowerDeviceState.Charging
    readonly property bool warning: percent < 20
    readonly property bool low: percent < 5

    hidden: !battery.isLaptopBattery
    clickable: false

    text: percent + " %"
    iconColor: charging ? Style.battery_charge : warning ? Style.battery_warn : low ? Style.battery_low : Style.accent

    icon: charging ? "󰂄" : low ? "󰁻" : "󰂀"
}
