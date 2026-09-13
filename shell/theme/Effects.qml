pragma Singleton
import QtQuick

Item {







    readonly property real baseOpacity:   Motion.visualMode === Motion.Lite ? 0.92
        : (Motion.reducedMotion ? 0.86 : 0.0)

    readonly property bool blurEnabled:        Motion.visualMode === Motion.Full
    readonly property bool artworkAtmosphere:  Motion.visualMode === Motion.Full
    readonly property bool ambientFocus:       Motion.visualMode === Motion.Balanced || Motion.visualMode === Motion.Full
    readonly property bool pulseEnabled:       Motion.visualMode === Motion.Full
    readonly property bool glowEnabled:        Motion.visualMode === Motion.Full

    readonly property int blurRadius: Motion.visualMode === Motion.Full ? 28
        : (Motion.visualMode === Motion.Balanced ? 16 : 0)

    readonly property real shadowOpacity: Motion.visualMode === Motion.Full ? 0.35
        : (Motion.visualMode === Motion.Balanced ? 0.22 : 0.0)

    // Floating surfaces (popovers/panels) sit further off the canvas than
    // embedded cards, so their shadow should be visibly heavier — otherwise
    // a popover and a card in the same panel read as the same elevation.
    readonly property real shadowOpacityFloat: Motion.visualMode === Motion.Full ? 0.5
        : (Motion.visualMode === Motion.Balanced ? 0.34 : 0.0)

    readonly property real hairlineOpacity: 0.85


    readonly property real focusOpacity: Motion.visualMode === Motion.Full ? 0.30
        : (Motion.visualMode === Motion.Balanced ? 0.20 : 0.0)
    readonly property int focusRadius: Math.round(140 * Metrics.uiScale)

    readonly property real surfaceOpacity: Motion.reducedMotion ? 0.96 : Colors.surfaceOpacity
}