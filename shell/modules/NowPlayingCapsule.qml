import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../components"
import "../components/JeriIcons.js" as JeriIcons



Item {
    id: root
    property bool dashOpen: false
    property bool _visible: false
    property string _lastTitle: ""

    Timer {
        id: settle
        interval: 6000
        onTriggered: root._visible = false
    }

    function _sync() {
        if (!MediaService.hasPlayer) { if (!root.dashOpen) root._visible = false; root._lastTitle = ""; return }
        var t = MediaService.title
        if (root.dashOpen) { root._visible = false; root._lastTitle = ""; return }
        if (!root._lastTitle || root._lastTitle !== t) {
            root._lastTitle = t
            root._visible = true
            settle.restart()
        }
    }

    Connections {
        target: MediaService
        function onTitleChanged() { root._sync() }
        function onIsPlayingChanged() { root._sync() }
    }
    onDashOpenChanged: root._sync()

    visible: root._visible && root.visible
    opacity: root._visible ? 1 : 0
    scale: root._visible ? 1 : 0.97
    Behavior on opacity { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }
    Behavior on scale { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }

    implicitHeight: Metrics.controlHeight

    Rectangle {
        anchors.fill: parent
        radius: Metrics.radiusSm
        color: Colors.surfaceAlt
        opacity: Effects.surfaceOpacity
        border.color: Colors.border
        border.width: Metrics.borderWidth
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Metrics.padSm
        anchors.rightMargin: Metrics.padSm
        spacing: Metrics.gapXs

        Text {
            text: JeriIcons.code(MediaService.isPlaying ? "graphic_eq" : "music_note")
            font.family: "Material Symbols Outlined"
            font.pixelSize: Metrics.iconSm
            color: Colors.accent
        }
        Text {
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: MediaService.artist + "  ·  " + MediaService.title
            font.family: Typography.family
            font.pixelSize: Typography.sizeXs
            color: Colors.fgMuted
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.capsuleClicked()
    }
    signal capsuleClicked()
}