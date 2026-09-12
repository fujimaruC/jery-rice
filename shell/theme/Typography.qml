pragma Singleton
import QtQuick

Item {

    readonly property string family:     "Inter"
    readonly property string familyMono: "JetBrains Mono"


    readonly property real fontScale: 1.0

    readonly property int sizeXs:  Math.round(10 * fontScale)
    readonly property int sizeSm:  Math.round(12 * fontScale)
    readonly property int sizeMd:  Math.round(13 * fontScale)
    readonly property int sizeLg:  Math.round(16 * fontScale)
    readonly property int sizeXl:  Math.round(22 * fontScale)
    readonly property int size2xl: Math.round(28 * fontScale)

    readonly property int weightLight:  Font.Light
    readonly property int weightNormal: Font.Normal
    readonly property int weightMedium: Font.Medium
    readonly property int weightSemibold: Font.DemiBold
    readonly property int weightBold:   Font.Bold

    readonly property real lineHeightTight:  1.1
    readonly property real lineHeightNormal: 1.35

    readonly property real letterSpacingWide: 0.6
}