import QtQuick
import "../theme"



Item {
    id: root

    property bool checked: false
    property bool hovered: mouseArea.containsMouse
    property bool enabled: true

    signal toggled(bool value)

    width: Metrics.touchTarget * 1.7
    height: Metrics.controlHeight

    function setChecked(v) { root.checked = v }

    Rectangle {
        id: track
        anchors.fill: parent
        radius: Metrics.radiusFull
        color: root.checked ? Colors.accent : Colors.surfaceAlt
        border.color: root.checked ? Colors.accent : Colors.border
        border.width: Metrics.borderWidth


        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Colors.accentFaint
            opacity: root.checked && Effects.glowEnabled ? 0.7 : 0
            Behavior on opacity { NumberAnimation { duration: Motion.snappy } }
        }

        Behavior on color { ColorAnimation { duration: Motion.snappy } }
    }

    Rectangle {
        id: knob
        width: root.height - 4
        height: width
        radius: Metrics.radiusFull
        color: Colors.fg
        y: 2
        x: root.checked ? root.width - knob.width - 2 : 2

        Behavior on x {
            NumberAnimation {
                duration: Motion.snappy
                easing.type: Motion.easeOutBack
                easing.overshoot: 1.2
            }
        }
    }

    // This control is keyboard-operable (Keys.onPressed below) but had no
    // focus indicator at all — a keyboard user couldn't tell it was
    // selected. Same ring language as JeriCard/JeriButton.
    Rectangle {
        anchors.fill: parent
        anchors.margins: -Metrics.ringGap
        radius: Metrics.radiusFull
        color: "transparent"
        border.color: Colors.focusRing
        border.width: Metrics.ringWidth
        opacity: root.activeFocus ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: { root.setChecked(!root.checked); root.toggled(root.checked) }
        onPressed: root.forceActiveFocus()
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            root.setChecked(!root.checked); root.toggled(root.checked)
            event.accepted = true
        }
    }
}