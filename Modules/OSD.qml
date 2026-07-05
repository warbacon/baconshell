import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import qs.Commons
import qs.Services as Services

Scope {
    id: root

    enum Type { None, Volume, Brightness }

    property int currentType: root.Type.None
    property bool showOsd: false

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            root.currentType = root.Type.Volume;
            root.showOsd = true;
            hideTimer.restart();
        }

        function onMutedChanged() {
            onVolumeChanged();
        }
    }

    Connections {
        target: Services.Brightness

        function onBrightnessChanged() {
            root.currentType = root.Type.Brightness;
            root.showOsd = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: {
            root.showOsd = false;
            root.currentType = root.Type.None;
        }
    }

    PanelWindow {
        anchors.centerIn: parent

        exclusiveZone: 0
        color: "transparent"
        mask: Region {}

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        visible: root.showOsd

        width: 250
        height: 50

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: Color.mSurface
            border.color: Color.mOutline

            ColumnLayout {
                anchors {
                    fill: parent
                    margins: 12
                }
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true

                    IconImage {
                        implicitSize: 30
                        source: {
                            if (root.currentType === root.Type.Volume) {
                                const isMuted = Pipewire.defaultAudioSink?.audio.muted;
                                return isMuted
                                    ? Quickshell.iconPath("audio-volume-muted-symbolic")
                                    : Quickshell.iconPath("audio-volume-high-symbolic");
                            }
                            return Quickshell.iconPath("display-brightness-symbolic");
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true

                        implicitHeight: 8
                        radius: 20
                        color: Color.mSurfaceHighest

                        Rectangle {
                            color: Color.mPrimary
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                            }

                            width: parent.width * Math.max(0, Math.min(1, {
                                if (root.currentType === root.Type.Volume) {
                                    return Pipewire.defaultAudioSink?.audio.volume ?? 0;
                                }
                                return Services.Brightness.available
                                    ? Services.Brightness.currentBrightness / 100
                                    : 0;
                            }))
                            radius: parent.radius
                        }
                    }
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: {
                        if (root.currentType === root.Type.Volume) {
                            const vol = Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100);
                            const muted = Pipewire.defaultAudioSink?.audio.muted;
                            return muted ? `${vol}% (muted)` : `${vol}%`;
                        }
                        return Services.Brightness.available
                            ? `${Services.Brightness.currentBrightness}%`
                            : "";
                    }
                    color: Color.mOnSurfaceVariant
                }
            }
        }
    }
}
