import QtQuick
import QtQuick.Controls
import "../theme"



Item {
    id: root

    property string text: ""
    property string glyph: ""
    property color color: Colors.fg
    property bool accent: false
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

        background: Item {
            Rectangle {
                id: bg
                anchors.fill: parent
                radius: Metrics.radiusSm
                color: root.accent ? Colors.accent : Colors.surfaceAlt
                border.color: btn.hovered ? Colors.borderFocus : Colors.border
                border.width: Metrics.borderWidth
                Behavior on border.color { ColorAnimation { duration: Motion.fast } }

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

            // Keyboard-focus ring, same language as JeriCard/JeriToggle:
            // a distinct outer ring, never conflated with the hover border.
            Rectangle {
                anchors.fill: parent
                anchors.margins: -Metrics.ringGap
                radius: bg.radius + Metrics.ringGap
                color: "transparent"
                border.color: Colors.focusRing
                border.width: Metrics.ringWidth
                opacity: btn.visualFocus ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
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

        // Scale-down replaces the old 1px vertical nudge: at this control
        // size a translate that small is imperceptible, while a uniform
        // scale reads clearly as "pressed" without needing extra pixels.
        scale: btn.down ? Motion.pressScale : 1.0
        transformOrigin: Item.Center
        Behavior on scale { NumberAnimation { duration: Motion.snappy; easing.type: Motion.easeSnap } }
    }
}