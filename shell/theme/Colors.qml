pragma Singleton
import QtQuick

Item {



    readonly property color base:          "#0d0e11"
    readonly property color surface:       "#16181d"
    readonly property color surfaceAlt:    "#1d2027"
    readonly property color surfaceRaised: "#1c2027"
    readonly property color glass:         "#12141a"
    readonly property color border:        "#262b34"
    readonly property color borderFocus:   "#3d4a63"

    readonly property color fg:            "#e7e9ee"
    readonly property color fgMuted:       "#9aa1ad"
    readonly property color fgFaint:       "#6b727d"

    readonly property color accent:        "#7aa2f7"
    readonly property color accentMuted:   "#3a537f"
    readonly property color accentWarm:    "#e0a458"
    readonly property color accentSoft:    "#2e7aa2f7"
    readonly property color accentFaint:   "#1f7aa2f7"

    readonly property color hoverOverlay:  "#14ffffff"
    readonly property color pressOverlay:  "#26ffffff"

    readonly property color ok:            "#9ece6a"
    readonly property color warn:          "#e0a458"
    readonly property color danger:        "#f7768e"

    readonly property color scrim:         "#000000"
    readonly property real scrimOpacity:   0.35

    readonly property real surfaceOpacity: 0.92
}