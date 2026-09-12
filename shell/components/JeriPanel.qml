import QtQuick
import "../theme"




Item {
    id: root


    default property alias content: contentItem.data

    property color surface: Colors.surface
    property real surfaceOpacity: Effects.surfaceOpacity
    property color borderColor: Colors.border
    property int radius: Metrics.radiusMd
    property bool elevated: false

    Rectangle {
        id: shadow
        anchors.fill: parent
        anchors.topMargin: Metrics.shadowOffset
        radius: root.radius
        color: Colors.base
        opacity: root.elevated ? Effects.shadowOpacity : 0.0
        visible: root.elevated && Effects.shadowOpacity > 0
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: root.radius
        color: root.surface
        opacity: root.surfaceOpacity
        border.color: root.borderColor
        border.width: Metrics.borderWidth


        Rectangle {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.5
            height: Metrics.borderWidth
            color: Colors.accent
            opacity: root.elevated ? Effects.focusOpacity * 1.6 : 0
            Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
        }
    }

    Item {
        id: contentItem
        anchors.fill: parent
        anchors.margins: Metrics.padMd
        clip: true
    }
}