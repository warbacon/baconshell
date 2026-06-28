import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.Commons
import qs.Components

WrapperRectangle {
    id: root
    property MprisPlayer player: Mpris.players.values[0]
    visible: player
    color: Color.mSurfaceHigh
    radius: 8

    implicitHeight: 25
    rightMargin: 10
    leftMargin: 10

    RowLayout {
        spacing: 20
        StyledText {
            text: {
                const trackTitle = Mpris.players.values[0].trackTitle;
                const maxLength = 28;

                if (trackTitle.length > maxLength) {
                    return trackTitle.slice(0, maxLength) + "...";
                }

                return trackTitle;
            }
        }
        WrapperMouseArea {
            onClicked: {
                root.player.previous();
            }
            margin: 3
            StyledText {
                text: "<"
            }
        }
        WrapperMouseArea {
            onClicked: {
                root.player.togglePlaying();
            }
            margin: 3
            StyledText {
                text: root.player.isPlaying && "⏹" || "▶"
            }
        }
        WrapperMouseArea {
            onClicked: {
                root.player.next();
            }
            margin: 3
            StyledText {
                text: ">"
            }
        }
    }
}
