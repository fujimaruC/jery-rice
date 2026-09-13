pragma Singleton
import QtQuick

Item {





    enum Mode { Full, Balanced, Lite }

    property int visualMode: Motion.Balanced
    property bool reducedMotion: false


    readonly property real dt: !reducedMotion
        ? (visualMode === Motion.Full ? 1.0
          : (visualMode === Motion.Balanced ? 0.85 : 0.0))
        : 0.0





    readonly property int fast:   reducedMotion ? 40 : Math.round(140 * dt)
    readonly property int normal: reducedMotion ? 60 : Math.round(220 * dt)
    readonly property int slow:   reducedMotion ? 80 : Math.round(320 * dt)
    readonly property int snappy: reducedMotion ? 40 : Math.round(90 * dt)
    readonly property int gentle: reducedMotion ? 60 : Math.round(300 * dt)
    readonly property int exit:   reducedMotion ? 40 : Math.round(140 * dt)


    readonly property int easeOut:      Easing.OutCubic
    readonly property int easeInOut:    Easing.InOutCubic
    readonly property int easeOutBack:  Easing.OutBack
    readonly property int easeIn:       Easing.InCubic
    readonly property int easeSnap:     Easing.OutQuad
    readonly property int easeSmooth:   Easing.InOutQuad
    readonly property int easeExit:     Easing.InQuart


    readonly property bool motionAllowed: !reducedMotion && visualMode !== Motion.Lite

    // Press feedback: a 1px translate reads as nothing at UI scale. A small
    // uniform scale-down is the legible "physically pushed" cue and costs
    // nothing extra to animate. Collapses to 1.0 (no-op) under reduced motion.
    readonly property real pressScale: reducedMotion ? 1.0 : 0.97
}