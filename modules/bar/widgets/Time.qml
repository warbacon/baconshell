import Quickshell
import QtQuick
import qs.style

BarButton {
    clickable: true
    icon: showTime ? "" : ""

    property bool showTime: true
    property string dateFormat: showTime ? "hh:mm" : "ddd, d MMM"

    onClicked: showTime = !showTime
    text: Qt.locale().toString(clock.date, dateFormat)

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
