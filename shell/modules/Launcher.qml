import Quickshell
import QtQuick
import QtQuick.Layouts
import "../theme"
import "../components"
import "../components/JeriIcons.js" as JeriIcons



PanelWindow {
    id: root

    anchors.fill: true
    color: "transparent"
    focusable: true
    layer: Quickshell.WindowLayer.Overlay

    property bool open: false
    property string query: ""
    property var apps: DesktopEntries.applications ? DesktopEntries.applications.values : []
    property var results: []

    function matches() {
        var q = root.query.trim().toLowerCase()
        if (!q) { results = []; return }
        var scored = []
        for (var i = 0; i < root.apps.length; i++) {
            var a = root.apps[i]
            var name = (a.name || "")
            var generic = (a.genericName || "")
            var hit = name.toLowerCase()
            var gi = generic.toLowerCase().indexOf(q)
            var ni = hit.indexOf(q)
            if (ni >= 0 || gi >= 0) {
                scored.push({ entry: a, score: (ni >= 0 ? ni : gi + 100) })
            }
        }
        scored.sort(function(x, y) { return x.score - y.score })
        results = scored.slice(0, 8).map(function(x) { return x.entry })
    }

    function open()   { root.visible = true; root.open = true; searchField.forceActiveFocus(); searchField.selectAll() }
    function close()  { root.open = false; root.visible = false }

    function launch(index) {
        var e = root.results[index]
        if (!e) return
        e.execute()
        root.close()
    }

    visible: false
    onVisibleChanged: if (visible) root.open()


    Rectangle {
        anchors.fill: parent
        color: Colors.scrim
        opacity: root.open ? Colors.scrimOpacity : 0
        Behavior on opacity { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }
        MouseArea { anchors.fill: parent; onClicked: root.close() }
    }


    Rectangle {
        id: surface
        anchors.top: parent.top
        anchors.topMargin: Metrics.barHeight + Metrics.gapLg
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width * 0.55, 560)
        radius: Metrics.radiusMd
        color: Colors.surface
        border.color: Colors.border
        border.width: Metrics.borderWidth
        opacity: root.open ? Effects.surfaceOpacity : 0
        scale: root.open ? 1 : 0.98
        Behavior on opacity { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }
        Behavior on scale { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }

        Column {
            anchors.fill: parent
            anchors.margins: Metrics.padMd
            spacing: Metrics.gapSm


RowLayout {
                width: parent.width
                spacing: Metrics.gapSm
                JeriIcon { glyph: "search"; size: Metrics.iconMd; color: Colors.fgMuted }
                TextEdit {
                    id: searchField
                    Layout.fillWidth: true
                    height: Metrics.touchTarget
                    color: Colors.fg
                    font.family: Typography.family
                    font.pixelSize: Typography.sizeMd
                    verticalAlignment: Text.AlignVCenter
                    selectByMouse: true
                    onTextChanged: root.query = text
                    Keys.onReturnPressed: root.launch(0)
                    Keys.onEscapePressed: root.close()
                    Keys.onDownPressed: if (list.count > 0) list.currentIndex = 0
                }
            }


            ListView {
                id: list
                width: parent.width
                height: Math.min(root.results.length, 5) * (Metrics.touchTarget + Metrics.gapXs)
                model: root.results
                visible: root.results.length > 0
                spacing: Metrics.gapXs
                clip: true

                delegate: Item {
                    id: row
                    width: list.width
                    height: Metrics.touchTarget
                    opacity: 0


                    NumberAnimation {
                        running: row.opacity === 0
                        target: row
                        property: "opacity"
                        to: 1
                        duration: Motion.normal
                        easing.type: Motion.easeOut
                    }

                    Rectangle {
                        anchors.fill: parent
                        radius: Metrics.radiusSm
                        color: list.currentIndex === index ? Colors.accentSoft : "transparent"
                    }
                    RowLayout {
                        anchors.left: parent.left
                        anchors.leftMargin: Metrics.padSm
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: Metrics.gapSm
                        JeriIcon { glyph: "rocket"; size: Metrics.iconSm; color: Colors.accent }
                        Text {
                            text: modelData.name
                            font.family: Typography.family
                            font.pixelSize: Typography.sizeSm
                            color: Colors.fg
                            elide: Text.ElideRight
                            Layout.maximumWidth: surface.width * 0.6
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.launch(index)
                        onEntered: list.currentIndex = index
                    }
                }
            }

            Text {
                width: parent.width
                visible: root.results.length === 0 && root.query.length > 0
                text: "No matches"
                font.family: Typography.family
                font.pixelSize: Typography.sizeSm
                color: Colors.fgFaint
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Keys.onEscapePressed: root.close()
}