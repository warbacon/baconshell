import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import Quickshell.Widgets
import qs.Commons
import qs.Services as Services

Scope {
    id: root

    readonly property int typeNone: 0
    readonly property int typeVolume: 1
    readonly property int typeBrightness: 2

    property int currentType: root.typeNone
    property bool showOsd: false

    Connections {
        target: Pipewire.defaultAudioSink?.audio

        function onVolumeChanged() {
            root.currentType = root.typeVolume;
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
            root.currentType = root.typeBrightness;
            root.showOsd = true;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: {
            root.showOsd = false;
            root.currentType = root.typeNone;
        }
    }

    LazyLoader {
        active: root.showOsd

        PanelWindow {
            exclusiveZone: 0
            WlrLayershell.layer: WlrLayer.Overlay
            color: "transparent"

            mask: Region {}

            anchors.bottom: true
            margins.bottom: screen.height / 12

            visible: root.showOsd

            implicitWidth: 250
            implicitHeight: 60

            Rectangle {
                anchors.fill: parent
                radius: 8
                color: Color.mSurface
                border.color: Color.mOutline

                RowLayout {
                    anchors {
                        fill: parent
                        margins: 12
                    }
                    spacing: 8

                    IconImage {
                        implicitSize: 30
                        source: {
                            if (root.currentType === root.typeVolume) {
                                const isMuted = Pipewire.defaultAudioSink?.audio.muted;
                                return isMuted ? Quickshell.iconPath("audio-volume-muted-symbolic") : Quickshell.iconPath("audio-volume-high-symbolic");
                            }
                            if (root.currentType === root.typeBrightness) {
                                return Quickshell.iconPath("video-display-brightness-symbolic");
                            }
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

                            implicitWidth: {
                                if (root.currentType === root.typeVolume) {
                                    return parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0);
                                }

                                if (root.currentType === root.typeBrightness) {
                                    return parent.width * (Services.Brightness.currentBrightness / 100);
                                }
                            }
                            radius: parent.radius
                        }
                    }
                }
            }
        }
    }
}
