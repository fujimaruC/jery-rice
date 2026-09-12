import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import "../theme"
import "../services"
import "../components"



PanelWindow {
    id: root

    anchors {
        top: true
        right: true
        topMargin: Metrics.barHeight + Metrics.gapSm
        rightMargin: Metrics.padMd
    }

    width: 340
    height: 320
    color: "transparent"
    exclusiveZone: 0
    focusable: false

    ListModel {
        id: shown
    }
    property int maxVisible: 4

    function _refresh() {
        var vals = NotificationService.tracked ? NotificationService.tracked.values : []
        shown.clear()
        for (var i = 0; i < vals.length && i < root.maxVisible; i++) {
            var n = vals[i]
            if (ShellState.dnd && n.urgency === NotificationUrgency.Low) continue
            if (!n) continue
            shown.append({ n: n })
        }
    }

    Connections {
        target: NotificationService
        function onTrackedChanged() { root._refresh() }
        function onNotification() { root._refresh() }
    }
    Component.onCompleted: _refresh()

    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Metrics.gapSm

        Repeater {
            model: shown
            delegate: Item {
                id: toast
                width: 300
                height: 40
                opacity: 0

                Rectangle {
                    anchors.fill: parent
                    radius: Metrics.radiusMd
                    color: Colors.surfaceRaised
                    opacity: Effects.surfaceOpacity
                    border.color: Colors.border
                    border.width: Metrics.borderWidth
                    Rectangle {
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: 2
                        radius: Metrics.radiusXs
                        color: Colors.accent
                        opacity: 0.6
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Metrics.padMd
                    anchors.rightMargin: Metrics.padMd
                    spacing: Metrics.gapSm

                    Text {
                        text: model.n.appName || "Notification"
                        font.family: Typography.family
                        font.pixelSize: Typography.sizeXs
                        font.weight: Typography.weightSemibold
                        color: Colors.fgMuted
                        elide: Text.ElideRight
                    }
                    Rectangle {
                        width: 8; height: 8
                        radius: 4
                        color: model.n.urgency === NotificationUrgency.Critical
                            ? Colors.danger : Colors.fgFaint
                        visible: model.n.urgency !== NotificationUrgency.Normal
                    }
                    Text {
                        Layout.fillWidth: true
                        text: model.n.text || model.n.summary || ""
                        font.family: Typography.family
                        font.pixelSize: Typography.sizeSm
                        color: Colors.fg
                        elide: Text.ElideRight
                    }
                }

                NumberAnimation {
                    running: toast.opacity === 0
                    target: toast
                    property: "opacity"
                    to: 1
                    duration: Motion.fast
                    easing.type: Motion.easeOut
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: NotificationService.dismiss(model.n)
                }
            }
        }
    }
}