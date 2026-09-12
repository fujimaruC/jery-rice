import QtQuick
import "../theme"


Item {
    id: root

    property real value: 0
    property string label: ""
    property string unit: "%"
    property color color: Colors.accent
    property color trackColor: Colors.surfaceAlt

    implicitWidth: Metrics.iconMd * 5
    implicitHeight: Metrics.iconMd * 5

    Canvas {
        id: ring
        anchors.fill: parent
        antialiasing: true

        property real frac: root.value

        onFracChanged: requestPaint()
        Component.onCompleted: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            var cx = width / 2
            var cy = height / 2
            var r = Math.min(width, height) / 2 - Metrics.progressThickness
            var a0 = -Math.PI / 2
            var a1 = a0 + Math.max(0.04, Math.min(1, frac)) * 2 * Math.PI

            ctx.lineWidth = Metrics.progressThickness
            ctx.strokeStyle = root.trackColor
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, 2 * Math.PI)
            ctx.stroke()

            ctx.strokeStyle = root.color
            ctx.globalAlpha = Math.max(0.05, Math.min(1, frac))
            ctx.lineCap = "round"
            ctx.beginPath()
            ctx.arc(cx, cy, r, a0, a1)
            ctx.stroke()
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 2
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(root.value * 100) + root.unit
            font.family: Typography.familyMono
            font.pixelSize: Typography.sizeMd
            font.weight: Typography.weightSemibold
            color: Colors.fg
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.label
            font.family: Typography.family
            font.pixelSize: Typography.sizeXs
            color: Colors.fgFaint
        }
    }
}