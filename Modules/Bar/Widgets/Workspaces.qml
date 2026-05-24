import QtQuick
import Quickshell.WindowManager
import qs.Modules.Bar.Extras
import qs.Commons

Row {
    property var workspaces: {
        const arr = Array.from(WindowManager.windowsets).sort((a, b) => {
            return parseInt(a.name) - parseInt(b.name);
        });

        return arr;
    }

    spacing: 4

    Repeater {
        model: parent.workspaces

        Pill {
            required property Windowset modelData

            clickable: true
            onClicked: {
                modelData.activate();
            }
            text: modelData.name
            textColor: modelData.active ? Color.mOnPrimary : Color.mOnSurface
            bgColor: modelData.active ? Color.mPrimary : Color.mSurfaceHigh
        }
    }
}
