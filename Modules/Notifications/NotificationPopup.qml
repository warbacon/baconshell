import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import qs.Commons

Rectangle {
    id: root

    property var notification: null

    signal dismissed

    implicitWidth: 320
    implicitHeight: content.implicitHeight + 24

    color: Color.mSurfaceHighest
    radius: 10

    border {
        width: 2
        color: root.notification.urgency == NotificationUrgency.Critical ? Color.mError : Color.mPrimary
    }

    Connections {
        target: root.notification

        function onClosed() {
            root.dismissed();
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        function invokeDefaultAction() {
            if (!root.notification) {
                return;
            }

            for (let i = 0; i < root.notification.actions.length; ++i) {
                const action = root.notification.actions[i];

                if (action.identifier === "default") {
                    action.invoke();
                    return;
                }
            }

            root.notification.dismiss();
        }

        onClicked: function (mouse) {
            if (!root.notification) {
                return;
            }

            if (mouse.button === Qt.MiddleButton) {
                root.notification.dismiss();
                return;
            }

            invokeDefaultAction();
        }
    }

    RowLayout {
        id: content

        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        IconImage {
            visible: root.notification && root.notification.appIcon !== ""
            implicitSize: 24
            source: root.notification ? Quickshell.iconPath(root.notification.appIcon) : ""
        }

        ColumnLayout {
            Layout.fillWidth: true

            Text {
                Layout.fillWidth: true
                text: root.notification ? root.notification.summary : ""
                textFormat: Text.PlainText
                color: Color.mOnSurface
                font.family: Style.fontFamily
                font.pointSize: 10
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                visible: root.notification && root.notification.body !== ""
                text: root.notification ? root.notification.body : ""
                font.family: Style.fontFamily
                font.pointSize: 10
                textFormat: Text.PlainText
                color: Color.mOnSurface
                wrapMode: Text.WordWrap
            }
        }
    }
}
