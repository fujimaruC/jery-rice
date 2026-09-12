import QtQuick
import "../theme"



Item {
    id: root

    property string text: ""
    property string glyph: ""
    property bool selected: false
    property bool hovered: mouseArea.containsMouse

    signal clicked()

    implicitWidth: row.implicitWidth + 2 * Metrics.padMd
    implicitHeight: Metrics.touchTarget

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Metrics.gapXs
        JeriIcon {
            visible: root.glyph !== ""
            glyph: root.glyph
            size: Metrics.iconSm
            color: root.selected ? Colors.accent : Colors.fgMuted
            Behavior on color { ColorAnimation { duration: Motion.fast } }
        }
        Text {
            text: root.text
            font.family: Typography.family
            font.pixelSize: Typography.sizeSm
            font.weight: root.selected ? Typography.weightSemibold : Typography.weightMedium
            color: root.selected ? Colors.fg : Colors.fgMuted
            Behavior on color { ColorAnimation { duration: Motion.fast } }
        }
    }


    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 2
        radius: Metrics.radiusXs
        color: Colors.accent
        opacity: root.selected ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: root.forceActiveFocus()
        onClicked: root.clicked()
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Space) {
            root.clicked()
            event.accepted = true
        }
    }
}