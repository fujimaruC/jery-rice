import QtQuick
import "../theme"




Item {
    id: root

    default property alias content: contentItem.data
    property color surface: Colors.surfaceAlt
    property color borderColor: Colors.border
    property int radius: Metrics.radiusMd
    property bool interactive: true

    property bool pressed: mouseArea.pressed && mouseArea.containsMouse
    property bool hovered: mouseArea.containsMouse
    property bool focused: activeFocus
    property bool activated: focused || hovered


    signal clicked()

    implicitWidth: contentItem.implicitWidth + 2 * Metrics.padMd
    implicitHeight: contentItem.implicitHeight + 2 * Metrics.padMd

    Rectangle {
        id: shadow
        anchors.fill: parent
        anchors.topMargin: Metrics.shadowOffset
        radius: root.radius
        color: Colors.base
        opacity: root.activated ? Effects.shadowOpacity : 0
        Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: root.radius
        color: root.surface
        border.color: root.focused ? Colors.borderFocus : root.borderColor
        border.width: Metrics.borderWidth


        Rectangle {
            anchors.fill: parent
            radius: root.radius
            color: Colors.accentSoft
            opacity: root.activated ? Effects.focusOpacity : 0
            Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
        }

        Item {
            id: contentItem
            anchors.fill: parent
            anchors.margins: Metrics.padMd
            clip: true
        }
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