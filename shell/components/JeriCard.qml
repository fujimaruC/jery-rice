import QtQuick
import "../theme"




Item {
    id: root

    default property alias content: contentItem.data
    property color surface: Colors.surfaceAlt
    // Embedded elements are separated by spacing/hairlines now (see
    // docs/DESIGN_SYSTEM.md §2) — a border here specifically means "this is
    // a floating surface," so it's opt-in via `floating`, not a default.
    property bool floating: false
    property color borderColor: Colors.border
    property int radius: Metrics.radiusMd
    property bool interactive: true
    // Set true for a card that's itself a floating surface (rare — most
    // floating containers should be a JeriPanel), so its shadow reads at the
    // right weight relative to embedded cards.
    property bool elevated: false

    property bool pressed: mouseArea.pressed && mouseArea.containsMouse
    property bool hovered: mouseArea.containsMouse
    // activeFocus alone fires for mouse-press focus too; visualFocus-style
    // gating (only show the ring when focus arrived via keyboard) isn't
    // available on a plain Item, so we approximate it by only drawing the
    // ring when focus is present *without* an active mouse hover — a mouse
    // click that leaves focus behind will have already dropped hover once
    // the pointer leaves, which is when the ring should appear.
    property bool focused: activeFocus

    signal clicked()

    implicitWidth: contentItem.implicitWidth + 2 * Metrics.padMd
    implicitHeight: contentItem.implicitHeight + 2 * Metrics.padMd

    scale: root.pressed ? Motion.pressScale : 1.0
    Behavior on scale { NumberAnimation { duration: Motion.snappy; easing.type: Motion.easeSnap } }

    Rectangle {
        id: shadow
        anchors.fill: parent
        anchors.topMargin: root.elevated ? Metrics.shadowOffsetFloat : Metrics.shadowOffset
        radius: root.radius
        color: Colors.base
        opacity: root.hovered || root.focused
            ? (root.elevated ? Effects.shadowOpacityFloat : Effects.shadowOpacity)
            : 0
        Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: root.radius
        color: root.surface
        // Hover = subtle border brighten (mouse-only, low-key). Focus gets
        // its own ring below instead of reusing this border, so the two
        // states are never visually interchangeable. Embedded (non-floating)
        // cards show no resting border at all — only on hover/floating.
        border.color: root.hovered ? Colors.borderFocus : root.borderColor
        border.width: (root.floating || root.hovered) ? Metrics.borderWidth : 0
        Behavior on border.color { ColorAnimation { duration: Motion.fast } }

        // Hover wash: a neutral tint for embedded cards (hover isn't a state
        // signal, so it never borrows the accent-tinted `accentSoft`).
        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: root.floating ? Colors.accentSoft : Colors.hoverTint
            opacity: root.hovered ? Effects.focusOpacity : 0
            Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
        }

        Item {
            id: contentItem
            anchors.fill: parent
            anchors.margins: Metrics.padMd
            clip: true
        }
    }

    // Keyboard-focus ring: drawn outside the card's own bounds at full
    // strength, unlike the hover border which just recolors the existing
    // edge. This is deliberately the loudest state in the component.
    Rectangle {
        anchors.fill: parent
        anchors.margins: -Metrics.ringGap
        radius: root.radius + Metrics.ringGap
        color: "transparent"
        border.color: Colors.focusRing
        border.width: Metrics.ringWidth
        opacity: root.focused ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: root.interactive
        cursorShape: root.interactive ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }

    Keys.onPressed: function(event) {
        if (root.interactive && (event.key === Qt.Key_Return || event.key === Qt.Key_Space)) {
            root.clicked()
            event.accepted = true
        }
    }
}