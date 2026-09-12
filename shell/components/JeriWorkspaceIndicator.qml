import QtQuick
import "../theme"


Item {
    id: root
    width: pill.width + 2 * Metrics.padXs
    height: Metrics.barHeight

    property bool active: false
    property alias workspaceId: label.text

    Rectangle {
        id: pill
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: root.active ? 26 : 10
        implicitHeight: root.active ? 20 : 6
        radius: root.active ? Metrics.radiusMd : Metrics.radiusXs / 2
        color: root.active ? Colors.accent : Colors.fgMuted
        opacity: root.active ? 1 : 0.5

        Behavior on implicitWidth  { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
        Behavior on implicitHeight { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
        Behavior on color          { ColorAnimation { duration: Motion.fast } }

        Text {
            id: label
            anchors.centerIn: parent
            visible: root.active
            text: root.workspaceId
            font.pixelSize: Typography.sizeXs
            font.weight: Typography.weightBold
            color: "#0d0e11"
        }
    }
}