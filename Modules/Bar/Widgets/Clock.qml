import Quickshell
import QtQuick
import qs.Modules.Bar.Extras

Pill {
    property bool showTime: true
    property string dateFormat: showTime ? "hh:mm" : "ddd, d MMM"

    icon: showTime ? "" : ""
    text: Qt.locale().toString(clock.date, dateFormat)

    clickable: true
    onClicked: showTime = !showTime

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
