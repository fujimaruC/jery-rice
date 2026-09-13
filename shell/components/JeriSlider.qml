import QtQuick
import "../theme"




Item {
    id: root

    property real from: 0
    property real to: 100
    property real value: 0
    property real stepSize: 1
    property string unit: "%"
    property string label: ""
    property bool enabled: true

    signal valueChanged(real value)
    signal changed(real value)

    width: 200
    height: Metrics.touchTarget

    readonly property real _frac: (root.value - root.from) / (root.to - root.from)
    property bool interacting: dragArea.drag.active


    property bool bubbleVisible: false
    Timer {
        id: bubbleTimer
        interval: 900
        onTriggered: root.bubbleVisible = false
    }
    function showBubble() {
        root.bubbleVisible = true
        bubbleTimer.restart()
    }

    onInteractingChanged: if (root.interacting) showBubble()
    onValueChanged: if (root.interacting) bubbleTimer.restart()

    Item {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: Metrics.progressThickness

        Rectangle {
            anchors.fill: parent
            radius: Metrics.radiusFull
            color: Colors.surfaceAlt
        }

        Rectangle {

            width: track.width * root._frac
            height: parent.height
            radius: Metrics.radiusFull
            color: Colors.accent
            Behavior on width {
                NumberAnimation {
                    duration: Motion.fast
                    easing.type: Motion.easeSmooth
                    enabled: !root.interacting
                }
            }
        }
    }

    Rectangle {
        id: knob
        width: Metrics.controlHeight
        height: width
        radius: Metrics.radiusFull
        color: Colors.fg
        x: track.x + track.width * root._frac - knob.width / 2
        y: (root.height - knob.height) / 2
        scale: dragArea.pressed ? Motion.pressScale : 1.0
        Behavior on scale { NumberAnimation { duration: Motion.snappy; easing.type: Motion.easeSnap } }

        Behavior on x {
            NumberAnimation {
                duration: Motion.fast
                easing.type: Motion.easeSmooth
                enabled: !root.interacting
            }
        }
    }


    Rectangle {
        id: bubble
        width: bubbleText.width + Metrics.padMd
        height: Metrics.controlHeight
        radius: Metrics.radiusSm
        color: Colors.surfaceRaised
        border.color: Colors.borderFocus
        border.width: Metrics.borderWidth
        anchors.bottom: track.top
        anchors.bottomMargin: Metrics.gapXs
        anchors.horizontalCenter: knob.horizontalCenter
        opacity: root.bubbleVisible ? 1 : 0
        scale: root.bubbleVisible ? 1 : 0.85
        Behavior on opacity { NumberAnimation { duration: Motion.snappy; easing.type: Motion.easeOut } }
        Behavior on scale { NumberAnimation { duration: Motion.snappy; easing.type: Motion.easeOutBack } }

        Text {
            id: bubbleText
            anchors.centerIn: parent
            text: root.label + " " + Math.round(root.value) + root.unit
            font.family: Typography.familyMono
            font.pixelSize: Typography.sizeXs
            color: Colors.fg
        }
    }

    // JeriSlider handles Keys.onPressed for arrow-key adjustment but had no
    // focus visual at all — same gap fixed on JeriToggle/ToggleRow.
    Rectangle {
        anchors.left: track.left
        anchors.right: track.right
        anchors.verticalCenter: track.verticalCenter
        anchors.margins: -Metrics.ringGap
        height: track.height + 2 * Metrics.ringGap
        radius: Metrics.radiusFull
        color: "transparent"
        border.color: Colors.focusRing
        border.width: Metrics.ringWidth
        opacity: root.activeFocus ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onPressed: root.forceActiveFocus()
        onPositionChanged: root._dragSet(mouse.x)
        onReleased: root._finish()
    }

    Keys.onPressed: function(event) {
        var d = 0
        if (event.key === Qt.Key_Left || event.key === Qt.Key_Down) d = -root.stepSize
        else if (event.key === Qt.Key_Right || event.key === Qt.Key_Up) d = root.stepSize
        var snapped = Math.round((root.value - root.from) / root.stepSize) * root.stepSize
        root._setValue(snapped + d)
        if (d !== 0) { showBubble(); event.accepted = true }
    }

    function _dragSet(x) {
        var r = track.width
        var f = r > 0 ? (x - track.x) / r : 0
        var raw = root.from + Math.max(0, Math.min(1, f)) * (root.to - root.from)
        _setValue(raw)
    }

    function _setValue(v) {
        var clamped = Math.max(root.from, Math.min(root.to, v))
        var stepped = Math.round((clamped - root.from) / root.stepSize) * root.stepSize + root.from
        if (root.value !== stepped) {
            root.value = stepped
            valueChanged(stepped)
        }
    }

    function _finish() { changed(root.value) }
}