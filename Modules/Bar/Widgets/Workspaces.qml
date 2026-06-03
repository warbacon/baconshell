import QtQuick
import Quickshell
import Quickshell.WindowManager
import qs.Modules.Bar.Extras
import qs.Commons

Rectangle {
    id: root

    required property ShellScreen screen

    color: Color.mSurfaceHigh
    radius: 8

    property var workspaces: {
        const arr = Array.from(WindowManager.screenProjection(root.screen).windowsets).sort((a, b) => {
            return parseInt(a.name) - parseInt(b.name);
        });

        return arr;
    }

    implicitHeight: row.implicitHeight
    implicitWidth: row.implicitWidth

    Row {
        id: row

        anchors.fill: parent
        spacing: 4

        Repeater {
            model: root.workspaces

            WorkspaceItem {
                required property Windowset modelData

                active: modelData.active
                text: modelData.name

                onClicked: {
                    modelData.activate();
                }
            }
        }
    }
}
