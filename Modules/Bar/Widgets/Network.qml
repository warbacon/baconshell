import QtQuick
import Quickshell.Io
import qs.Modules.Bar.Extras
import qs.Commons

Pill {
    id: root

    property string connectionName: ""
    property string connectionType: ""
    property bool isConnected: false
    property int signalStrength: 0

    iconColor: isConnected ? Color.mPrimary : Color.mOnSurfaceVariant
    textColor: isConnected ? Color.mOnSurface : Color.mOnSurfaceVariant

    icon: {
        if (connectionType === "wifi") {
            if (signalStrength >= 80)
                return "󰤨";
            else if (signalStrength >= 60)
                return "󰤥";
            else if (signalStrength >= 40)
                return "󰤢";
            else if (signalStrength >= 20)
                return "󰤟";
            else
                return "󰤯";
        }
        if (connectionType === "ethernet")
            return "󰈀";

        return "󰌙";
    }

    text: isConnected ? connectionName : "Sin conexión"

    clickable: true
    acceptedButtons: Qt.RightButton

    onClicked: mouse => {
        networkManager.running = !networkManager.running;
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            networkStatus.running = true;
        }
    }

    Process {
        id: ipProcess
        command: ["ip", "-4", "addr", "show", "scope", "global"]

        stdout: StdioCollector {
            onStreamFinished: {
                const match = text.match(/inet (\d+\.\d+\.\d+\.\d+)/);

                if (match) {
                    root.text = match[1];
                } else {
                    root.text = "IP desconocida";
                }
            }
        }
    }

    Process {
        id: networkStatus
        command: ["nmcli", "-t", "-f", "NAME,TYPE", "connection", "show", "--active"]

        stdout: StdioCollector {
            id: outputParser
            onStreamFinished: {
                var lines = text.split("\n");

                var firstLine = lines[0];
                if (firstLine == "lo:loopback") {
                    root.isConnected = false;
                } else {
                    root.isConnected = true;
                    var type = firstLine.split(":")[1];
                    if (type === "802-11-wireless" || type === "wireless") {
                        root.connectionType = "wifi";
                        root.connectionName = firstLine.split(":")[0];
                        signalChecker.running = true;
                    } else if (type === "802-3-ethernet" || type === "ethernet") {
                        root.connectionType = "ethernet";
                        root.signalStrength = 0;
                        ipProcess.running = true;
                    } else {
                        root.connectionType = type;
                        root.signalStrength = 0;
                    }
                }
            }
        }
    }

    Process {
        id: signalChecker
        command: ["nmcli", "-t", "-f", "SIGNAL", "device", "wifi", "list", "--rescan", "no"]

        stdout: StdioCollector {
            onStreamFinished: {
                var lines = text.split("\n");
                if (lines.length > 0 && lines[0] !== "") {
                    root.signalStrength = parseInt(lines[0]);
                }
            }
        }
    }

    Process {
        id: networkManager
        command: ["xdg-terminal-exec", "nmtui"]
    }
}
