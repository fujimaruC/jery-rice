import Quickshell
import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"
import "../components"
import "../modules"




PanelWindow {
    id: root

    property bool open: false
    property int currentIndex: 0

    anchors {
        top: true
        left: true
        right: true
        topMargin: Metrics.barHeight + Metrics.gapSm
        leftMargin: Metrics.padMd
        rightMargin: Metrics.padMd
    }

    color: "transparent"
    focusable: true
    exclusiveZone: 0



    height: root.open ? body.implicitHeight + 2 * Metrics.padMd : Metrics.borderWidth
    opacity: root.open ? 1 : 0
    Behavior on height { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }
    Behavior on opacity { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }

    function setOpen(v) {
        root.open = v
        if (v) root.visible = true
    }
    onHeightChanged: if (!root.open && height <= Metrics.borderWidth) root.visible = false

    Keys.onEscapePressed: root.setOpen(false)

    // Same floating-popover tier as ControlCenter — was left on the L1
    // "surface" token, which made two popovers in the same shell disagree
    // about which elevation tier a popover actually is.
    Rectangle {
        id: shadow
        anchors.fill: parent
        anchors.topMargin: Metrics.shadowOffsetFloat
        radius: Metrics.radiusLg
        color: Colors.base
        opacity: Effects.shadowOpacityFloat
        visible: root.open
    }

    Rectangle {
        id: body
        anchors.fill: parent
        opacity: Effects.surfaceOpacity
        radius: Metrics.radiusLg
        color: Colors.surfaceRaised
        border.color: Colors.border
        border.width: Metrics.borderWidth
        Behavior on radius { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }

        Column {
            id: col
            anchors.fill: parent
            anchors.margins: Metrics.padMd
            spacing: Metrics.gapSm


            Row {
                id: tabRow
                width: parent.width
                spacing: Metrics.gapXs
                height: Metrics.touchTarget

                Repeater {
                    model: ["dashboard", "stream", "graphic_eq"]
                    delegate: JeriTab {
                        readonly property string _tabName: ["Dashboard", "Media", "Performance"][index]
                        readonly property bool _isTab: true
                        text: _tabName
                        glyph: modelData
                        selected: root.currentIndex === index
                        onClicked: root.select(index)
                    }
                }


                Rectangle {
                    id: tabIndicator
                    width: root.currentIndex < tabRow.tabs().length
                        ? tabRow.tabs()[root.currentIndex].width : 0
                    height: 2
                    radius: Metrics.radiusXs
                    color: Colors.accent
                    anchors.bottom: tabRow.bottom
                    x: tabRow.tabsOffset()
                    Behavior on width { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
                    Behavior on x {
                        NumberAnimation {
                            duration: Motion.fast
                            easing.type: Motion.easeOut
                        }
                    }
                }


                function tabs() {
                    var out = []
                    for (var i = 0; i < tabRow.children.length; i++)
                        if (tabRow.children[i]._isTab) out.push(tabRow.children[i])
                    return out
                }
                function tabsOffset() {
                    var acc = 0
                    var t = tabRow.tabs()
                    for (var i = 0; i < root.currentIndex; i++)
                        acc += t[i].width + tabRow.spacing
                    return acc
                }
            }


            Item {
                id: stackHost
                width: parent.width



                Rectangle {
                    id: focusField
                    anchors.fill: parent
                    radius: Metrics.radiusLg
                    color: Colors.accentSoft
                    opacity: root.focusPulse && Effects.ambientFocus
                        ? root.focusPulse : 0
                    Behavior on opacity {
                        NumberAnimation { duration: Motion.gentle; easing.type: Motion.easeOut }
                    }
                }

                Item {
                    id: stack
                    anchors.fill: parent
                    height: Math.max(pageDash.implicitHeight,
                               Math.max(pageMedia.implicitHeight, pagePerf.implicitHeight))

                    DashboardPage {
                        id: pageDash
                        anchors.fill: stack
                        visible: root.currentIndex === 0
                    }
                    MediaPage {
                        id: pageMedia
                        anchors.fill: stack
                        visible: root.currentIndex === 1
                    }
                    PerfPage {
                        id: pagePerf
                        anchors.fill: stack
                        visible: root.currentIndex === 2
                    }
                }
            }
        }
    }

    property real focusPulse: 0
    Timer {
        id: pulseTimer
        interval: 500
        onTriggered: root.focusPulse = 0
    }


    function select(i) {
        if (i === root.currentIndex) return
        var dir = i > root.currentIndex ? 1 : -1
        root.currentIndex = i
        stack.opacity = 0
        stack.x = dir * 16
        pageIn.restart()
        root.focusPulse = Effects.focusOpacity
        pulseTimer.start()
    }

    ParallelAnimation {
        id: pageIn
        NumberAnimation {
            target: stack
            property: "opacity"
            to: 1
            duration: Motion.normal
            easing.type: Motion.easeOut
        }
        NumberAnimation {
            target: stack
            property: "x"
            to: 0
            duration: Motion.normal
            easing.type: Motion.easeOut
        }
    }


    component DashboardPage: Item {
        implicitHeight: 232

        RowLayout {
            anchors.fill: parent
            spacing: Metrics.gapLg

            Calendar {
                Layout.alignment: Qt.AlignTop
            }

            Column {
                Layout.alignment: Qt.AlignTop
                spacing: Metrics.gapMd
                width: Math.max(220, root.width * 0.3)

                Text {
                    id: bigClock
                    text: {
                        var h = clock2.hours
                        var m = clock2.minutes
                        var am = h < 12 ? "AM" : "PM"
                        var hh = h % 12 || 12
                        return hh + ":" + (m < 10 ? "0" + m : m) + " " + am
                    }
                    font.family: Typography.familyMono
                    font.pixelSize: Typography.size2xl
                    font.weight: Typography.weightSemibold
                    color: Colors.fg
                    SystemClock {
                        id: clock2
                        precision: SystemClock.Minutes
                    }
                }

                Text {
                    text: Qt.formatDate(new Date(), "dddd, MMMM d")
                    font.family: Typography.family
                    font.pixelSize: Typography.sizeSm
                    color: Colors.fgMuted
                }


                Row {
                    spacing: Metrics.gapXs
                    Repeater {
                        model: HyprlandService.sortedWorkspaces()
                        Rectangle {
                            property bool act: HyprlandService.focusedWorkspace === modelData
                            width: act ? 22 : 9
                            height: 18
                            radius: Metrics.radiusXs
                            color: act ? Colors.accent : Colors.fgMuted
                            opacity: act ? 1 : 0.4
                            Behavior on width { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
                            Behavior on color { ColorAnimation { duration: Motion.fast } }
                            Text {
                                anchors.centerIn: parent
                                visible: parent.act
                                text: modelData.id
                                font.pixelSize: Typography.sizeXs
                                font.weight: Typography.weightBold
                                color: Colors.base
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: HyprlandService.switchWorkspace(modelData.id)
                            }
                        }
                    }
                }


                Column {
                    spacing: Metrics.gapXs
                    Row {
                        spacing: Metrics.gapXs
                        JeriIcon { glyph: BatteryService.present
                            ? (BatteryService.charging ? "battery_charging"
                              : BatteryService.percentage > 60 ? "battery_full"
                              : BatteryService.percentage > 25 ? "battery4"
                              : "battery_alert")
                            : "power"; size: Metrics.iconSm; color: Colors.fgMuted }
                        Text {
                            text: BatteryService.present ? BatteryService.percentage + "%"
                                : "Desktop power"
                            font.family: Typography.family
                            font.pixelSize: Typography.sizeXs
                            color: Colors.fgMuted
                        }
                    }
                    Row {
                        spacing: Metrics.gapXs
                        JeriIcon {
                            glyph: NetworkService.wifi ? "wifi" : (NetworkService.wired ? "network_check" : "power")
                            size: Metrics.iconSm
                            color: NetworkService.active ? Colors.fgMuted : Colors.fgFaint
                        }
                        Text {
                            text: NetworkService.active ? "Connected" : "Offline"
                            font.family: Typography.family
                            font.pixelSize: Typography.sizeXs
                            color: Colors.fgMuted
                        }
                    }
                    Row {
                        spacing: Metrics.gapXs
                        JeriIcon {
                            glyph: AudioService.muted ? "volume_off" : "volume_up"
                            size: Metrics.iconSm
                            color: Colors.fgMuted
                        }
                        Text {
                            text: AudioService.muted ? "Muted" : Math.round(AudioService.volume * 100) + "%"
                            font.family: Typography.family
                            font.pixelSize: Typography.sizeXs
                            color: Colors.fgMuted
                        }
                    }
                }
            }
        }
    }

    component MediaPage: Item {
        implicitHeight: 150
        MediaPlayer {
            anchors.centerIn: parent
        }
    }

    component PerfPage: Item {
        implicitHeight: 200
        Performance {
            anchors.centerIn: parent
        }
    }
}