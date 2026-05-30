import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Commons

Rectangle {
    id: root

    required property var notification
    required property int index
    required property int totalCount

    implicitWidth: 350
    implicitHeight: contentLayout.implicitHeight + 20

    radius: 8
    color: {
        switch (notification.urgency) {
            case 2: // Critical
                return Color.mError
            case 1: // Normal
                return Color.mSurfaceHigh
            default: // Low
                return Color.mSurface
        }
    }

    border {
        width: 1
        color: Color.mOutline
    }

    // Auto-dismiss timer
    Timer {
        id: dismissTimer
        interval: {
            // Critical notifications stay longer, low urgency disappears faster
            if (notification.urgency === 2) return 7000
            if (notification.urgency === 0) return 4000
            return 5000
        }
        onTriggered: notification.expire()
    }

    Component.onCompleted: {
        if (notification.expireTimeout !== 0) {
            dismissTimer.start()
        }
    }

    ColumnLayout {
        id: contentLayout
        anchors {
            fill: parent
            margins: 12
        }
        spacing: 8

        // Header: app icon + title + close button
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            IconImage {
                source: notification.appIcon
                implicitSize: 24
                visible: notification.appIcon !== ""
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    Layout.fillWidth: true
                    text: notification.appName
                    color: Color.mOnSurfaceVariant
                    font.pointSize: Style.fontSize - 1
                    font.weight: Font.Bold
                    elide: Text.ElideRight
                }

                Text {
                    Layout.fillWidth: true
                    text: notification.summary
                    color: Color.mOnSurface
                    font.pointSize: Style.fontSize
                    font.weight: Font.Bold
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                }
            }

            MouseArea {
                implicitWidth: 20
                implicitHeight: 20
                cursorShape: Qt.PointingHandCursor

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: Color.mOnSurface
                    font.pointSize: Style.fontSize + 2
                }

                onClicked: notification.dismiss()
            }
        }

        // Body
        Text {
            Layout.fillWidth: true
            visible: notification.body !== ""
            text: notification.body
            color: Color.mOnSurfaceVariant
            font.pointSize: Style.fontSize - 1
            wrapMode: Text.Wrap
            elide: Text.ElideRight
            maximumLineCount: 3
        }

        // Image
        Image {
            Layout.fillWidth: true
            visible: notification.image !== ""
            source: notification.image
            implicitHeight: 150
            fillMode: Image.PreserveAspectCrop
            smooth: true
        }

        // Actions
        RowLayout {
            Layout.fillWidth: true
            visible: notification.actions.length > 0
            spacing: 8

            Repeater {
                model: notification.actions

                delegate: Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 32
                    radius: 4
                    color: Color.mSurfaceHighest

                    border {
                        width: 1
                        color: Color.mOutline
                    }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.text
                        color: Color.mOnSurface
                        font.pointSize: Style.fontSize - 1
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            modelData.invoke()
                            notification.dismiss()
                        }
                    }
                }
            }
        }
    }

    // Slide out animation on removal
    NumberAnimation {
        id: slideOut
        target: root
        property: "opacity"
        from: 1
        to: 0
        duration: 200
    }

    function removeAnimated() {
        slideOut.start()
    }
}
