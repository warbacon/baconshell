import Quickshell.Services.UPower
import QtQuick
import qs.Modules.Bar.Extras
import qs.Commons

Pill {
    property var device: UPower.displayDevice
    property bool isCharging: device.state === UPowerDeviceState.Charging
    property bool isDischarging: device.state === UPowerDeviceState.Discharging
    property bool isFull: device.state === UPowerDeviceState.FullyCharged
    property int batteryPercentage: device.percentage * 100

    visible: device.isLaptopBattery

    icon: {
        if (isCharging)
            return "󰂄";

        if (batteryPercentage >= 90)
            return "󰁹";
        if (batteryPercentage >= 80)
            return "󰂂";
        if (batteryPercentage >= 70)
            return "󰂁";
        if (batteryPercentage >= 60)
            return "󰂀";
        if (batteryPercentage >= 50)
            return "󰁿";
        if (batteryPercentage >= 40)
            return "󰁾";
        if (batteryPercentage >= 30)
            return "󰁽";
        if (batteryPercentage >= 20)
            return "󰁼";
        if (batteryPercentage >= 10)
            return "󰁻";
        return "󰁺";
    }

    iconColor: {
        if (isCharging)
            return Color.mCharging;
        if (batteryPercentage <= 5)
            return Color.mError;
        if (batteryPercentage <= 20)
            return Color.mWarn;
        return Color.mPrimary;
    }

    text: `${batteryPercentage} %`
}
