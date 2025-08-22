pragma Singleton
import QtQuick

QtObject {
    property string fontFamily: "monospace"

    // Background
    property string bg0: "#111118"
    property string bg1: "#1a1b26"
    property string bg2: "#292e42"

    // Foreground
    property string fg0: "#a9b1d6"
    property string fg1: "#c0caf5"

    // Borders
    property string border0: "#232533"
    property string border1: "#424b6b"

    // Accents
    property string accent: "#449dab"
    property string red: "#f7768e"
    property string green: "#9ece6a"

    // Battery
    property string battery_low: red
    property string battery_warn: "#ff9e64"
    property string battery_charge: "#e0af68"

    // Workspace
    property string workspace_active_bg: accent
    property string workspace_active_fg: bg1
}
