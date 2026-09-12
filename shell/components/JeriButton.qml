import QtQuick
import QtQuick.Controls
import "../theme"



Item {
    id: root

    property string text: ""
    property string glyph: ""
    property color color: Colors.fg
    property color accent: false
    property bool focusable: true

    property bool pressed: btn.down
    property bool hovered: btn.hovered
    property bool enabled: true

    signal clicked()

    implicitWidth: btn.implicitWidth
    implicitHeight: btn.implicitHeight

    Button {
        id: btn
        anchors.fill: parent
        focusPolicy: root.focusable ? Qt.StrongFocus : Qt.NoFocus
        enabled: root.enabled

        onClicked: root.clicked()

        background: Rectangle {
            id: bg
            radius: Metrics.radiusSm
            color: root.accent ? Colors.accent : Colors.surfaceAlt
            border.color: root.hovered ? Colors.borderFocus : Colors.border
            border.width: Metrics.borderWidth


            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: Colors.hoverOverlay
                opacity: btn.hovered ? 1 : 0
            }
            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: Colors.pressOverlay
                opacity: btn.down ? 1 : 0
            }
        }

        contentItem: Item {
            implicitWidth: row.implicitWidth
            implicitHeight: row.implicitHeight
            Row {
                id: row
                anchors.centerIn: parent
                spacing: Metrics.gapXs
                JeriIcon {
                    visible: root.glyph !== ""
                    glyph: root.glyph
                    size: Metrics.iconSm
                    color: root.accent ? Colors.base : root.color
                }
                Text {
                    visible: root.text !== ""
                    text: root.text
                    font.family: Typography.family
                    font.pixelSize: Typography.sizeSm
                    font.weight: Typography.weightMedium
                    color: root.accent ? Colors.base : root.color
                }
            }
        }

        transform: Translate {

            y: btn.down ? 1 : 0
            Behavior on y { NumberAnimation { duration: Motion.snappy; easing.type: Motion.easeSnap } }
        }
    }
}