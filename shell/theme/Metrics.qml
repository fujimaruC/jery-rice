pragma Singleton
import QtQuick

Item {



    readonly property real uiScale: 1.0

    readonly property int barHeight:    Math.round(30 * uiScale)
    readonly property int dockHeight:   Math.round(4 * uiScale)


    readonly property int dashboardWidth:    Math.round(840 * uiScale)
    readonly property int dashboardWidthMin: Math.round(520 * uiScale)
    readonly property int dashboardGrowMs:   Motion.normal

    readonly property int controlHeight: Math.round(26 * uiScale)
    readonly property int touchTarget:   Math.round(32 * uiScale)

    readonly property int radiusXs: Math.round(4 * uiScale)
    readonly property int radiusSm: Math.round(6 * uiScale)
    readonly property int radiusMd: Math.round(10 * uiScale)
    readonly property int radiusLg: Math.round(16 * uiScale)
    readonly property int radiusFull: 9999

    readonly property int gapXs: Math.round(4 * uiScale)
    readonly property int gapSm: Math.round(8 * uiScale)
    readonly property int gapMd: Math.round(12 * uiScale)
    readonly property int gapLg: Math.round(20 * uiScale)

    readonly property int padXs: Math.round(4 * uiScale)
    readonly property int padSm: Math.round(8 * uiScale)
    readonly property int padMd: Math.round(12 * uiScale)
    readonly property int padLg: Math.round(16 * uiScale)

    readonly property int iconXs: Math.round(12 * uiScale)
    readonly property int iconSm: Math.round(14 * uiScale)
    readonly property int iconMd: Math.round(18 * uiScale)

    readonly property int shadowBlur:      Math.round(24 * uiScale)
    readonly property int shadowOffset:    Math.round(2 * uiScale)
    readonly property int shadowOffsetFloat: Math.round(6 * uiScale)
    readonly property int progressThickness: Math.round(3 * uiScale)
    readonly property int borderWidth: 1

    // Keyboard-focus ring: deliberately thicker than a resting/hover border
    // so focus is never mistaken for either. Drawn outside the element's own
    // bounds (see JeriCard/JeriButton/JeriToggle) rather than swapping the
    // border color, which is how hover already reads.
    readonly property int ringWidth: 2
    readonly property int ringGap:   2
}