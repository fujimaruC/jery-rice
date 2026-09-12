import QtQuick
import "../theme"
import "JeriIcons.js" as JeriIcons



Item {
    id: root

    property string glyph: ""
    property color color: Colors.fg
    property int size: Metrics.iconMd
    property int weight: Typography.weightMedium

    width: size
    height: size

    Text {
        id: label
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: JeriIcons.code(root.glyph)
        font.family: "Material Symbols Outlined"
        font.pixelSize: root.size
        font.weight: root.weight
        color: root.color
        font.letterSpacing: 0
        renderType: Text.QtRendering
    }
}