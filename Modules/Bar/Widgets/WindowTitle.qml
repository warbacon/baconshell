import QtQuick
import Quickshell.Wayland
import Quickshell
import Quickshell.Io
import qs.Modules.Bar.Extras

Pill {
    id: root

    property var topLevel: ToplevelManager.activeToplevel

    visible: text !== ""

    readonly property string socketPath: Quickshell.env("NIRI_SOCKET")

    Socket {
        id: eventSocket
        path: root.socketPath
        connected: true

        onConnectedChanged: {
            if (connected) {
                write(JSON.stringify("EventStream") + "\n");
                flush();
            }
        }

        parser: SplitParser {
            onRead: data => {
                try {
                    const event = JSON.parse(data);
                    if (event.WindowFocusChanged || event.WindowOpenedOrChanged) {
                        focusSocket.connected = true;
                    }
                } catch (e) {
                    console.error("Error parsing event:", e);
                }
            }
        }
    }

    Socket {
        id: focusSocket
        path: root.socketPath
        connected: true

        onConnectedChanged: {
            if (connected) {
                write(JSON.stringify("FocusedWindow") + "\n");
                flush();
            }
        }

        parser: SplitParser {
            onRead: data => {
                function truncate(str, maxLength) {
                    return str.length > maxLength ? str.slice(0, maxLength) + '...' : str;
                }

                try {
                    const event = JSON.parse(data).Ok?.FocusedWindow;
                    const appIcon = event ? DesktopEntries.byId(event.app_id)?.icon : null;
                    root.text = event ? truncate(event.title, 60) : "";
                    root.icon = appIcon ? `image://icon/${appIcon}` : "";
                } catch (e) {
                    console.error("Error parsing focused window:", e);
                } finally {
                    focusSocket.connected = false;
                }
            }
        }
    }
}
