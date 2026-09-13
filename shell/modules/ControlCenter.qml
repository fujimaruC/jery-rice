import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Bluetooth
import "../theme"
import "../services"
import "../components"




PanelWindow {
    id: root

    property bool open: false
    property int brightness: 80
    property bool nightLight: false

    readonly property int _panelWidth: Math.round(340 * Metrics.uiScale)

    anchors {
        top: true
        right: true
        topMargin: Metrics.barHeight + Metrics.gapSm
        rightMargin: Metrics.padMd
    }

    width: _panelWidth
    height: root.open ? col.implicitHeight + 2 * Metrics.padMd : Metrics.borderWidth
    opacity: root.open ? 1 : 0
    color: "transparent"
    exclusiveZone: 0
    focusable: true

    Behavior on height { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }
    Behavior on opacity { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }

    function setOpen(v) {
        root.open = v
        if (v) root.visible = true
    }
    onHeightChanged: if (!root.open && height <= Metrics.borderWidth) root.visible = false

    Keys.onEscapePressed: root.setOpen(false)

    // ControlCenter is a floating popover — the highest-elevation surface in
    // the shell — so it takes the lightest surface tier and the heaviest
    // shadow, rather than a mid-tier color that made it read as *less*
    // elevated than a plain embedded card.
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
        id: panel
        anchors.fill: parent
        radius: Metrics.radiusLg
        opacity: Effects.surfaceOpacity
        color: Colors.surfaceRaised
        border.color: Colors.border
        border.width: Metrics.borderWidth
        Behavior on radius { NumberAnimation { duration: Motion.normal; easing.type: Motion.easeOut } }

        Column {
            id: col
            anchors.fill: parent
            anchors.margins: Metrics.padLg
            spacing: Metrics.gapLg

            Column {
                width: parent.width
                spacing: Metrics.gapMd

                Row {
                    width: parent.width
                    spacing: Metrics.gapSm
                    JeriIcon { glyph: "brightness_high"; size: Metrics.iconSm; color: Colors.fg }
                    JeriSlider {
                        width: parent.width - Metrics.iconSm - Metrics.gapSm
                        from: 10; to: 100; stepSize: 5
                        value: root.brightness
                        onValueChanged: root.setBrightnessLevel(value)
                    }
                }

                Row {
                    width: parent.width
                    spacing: Metrics.gapSm
                    JeriIcon {
                        glyph: AudioService.muted ? "volume_off" : "volume_up"
                        size: Metrics.iconSm
                        color: AudioService.muted ? Colors.fgFaint : Colors.fg
                    }
                    JeriSlider {
                        width: parent.width - Metrics.iconSm - Metrics.gapSm
                        from: 0; to: 1; stepSize: 0.01
                        value: AudioService.volume
                        unit: ""
                        onValueChanged: AudioService.setVolume(value)
                    }
                }

                Row {
                    width: parent.width
                    spacing: Metrics.gapSm
                    JeriIcon {
                        glyph: AudioService.micMuted ? "mic_off" : "mic"
                        size: Metrics.iconSm
                        color: AudioService.micMuted ? Colors.fgFaint : Colors.fg
                    }
                    JeriToggle {
                        checked: !AudioService.micMuted
                        onToggled: AudioService.setMicMuted(!value)
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: AudioService.micMuted ? "Microphone off" : "Microphone live"
                        font.family: Typography.family
                        font.pixelSize: Typography.sizeSm
                        color: AudioService.micMuted ? Colors.fgFaint : Colors.fgMuted
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            // Hairline instead of a box around the quick-toggle grid below —
            // this is a section break within one floating surface, not a
            // reason for another nested card.
            Rectangle { width: parent.width; height: 1; color: Colors.line }

            Grid {
                columns: 2
                spacing: Metrics.gapSm
                width: parent.width

                ToggleRow { text: "Wi-Fi";      icon: "wifi";        on: root.wifiEnabled; onClicked: root.toggleWifi() }
                ToggleRow { text: "Bluetooth";  icon: "bluetooth";   on: root.btEnabled;   onClicked: root.toggleBt();
                    enabled: root.btPresent }
                ToggleRow { text: "Night Light"; icon: "nightlight"; on: root.nightLight;  onClicked: root.toggleNight() }
                ToggleRow { text: "Do Not Disturb"; icon: "notifications_off"; on: ShellState.dnd; onClicked: ShellState.toggleDnd() }
                ToggleRow {
                    text: "Visual " + (ShellState.visualMode === Motion.Full ? "Full"
                        : (ShellState.visualMode === Motion.Balanced ? "Balanced" : "Lite"))
                    icon: "tune"
                    on: true
                    onClicked: ShellState.cycleVisualMode()
                }
                ToggleRow {
                    text: "Reduced Motion"
                    icon: "bedtime"
                    on: ShellState.reducedMotion
                    onClicked: ShellState.reducedMotion = !ShellState.reducedMotion
                }
            }

            Rectangle { width: parent.width; height: 1; color: Colors.line }

            Text {
                width: parent.width
                text: BatteryService.present
                    ? "Battery " + BatteryService.percentage + "% "
                        + (BatteryService.charging ? "(charging)"
                          : BatteryService.fullyCharged ? "(full)" : "")
                    : "Desktop power"
                font.family: Typography.family
                font.pixelSize: Typography.sizeXs
                color: Colors.fgFaint
            }
        }
    }


    Process {
        id: readBrightness
        command: ["bash", "-c",
            "v=$(cat /sys/class/backlight/*/brightness 2>/dev/null | head -1); "
            + "m=$(cat /sys/class/backlight/*/max_brightness 2>/dev/null | head -1); "
            + "echo ${v:-0} ${m:-100}"]
        stdout: SplitParser {
            onRead: function(line) {
                var p = line.trim().split(/\s+/)
                if (p.length === 2 && parseInt(p[1]) > 0)
                    root.brightness = Math.round(parseInt(p[0]) / parseInt(p[1]) * 100)
            }
        }
    }
    Process {
        id: setBrightness
        command: []
    }
    function setBrightnessLevel(v) {
        root.brightness = v
        setBrightness.command = ["brightnessctl", "set", Math.round(v) + "%"]
        setBrightness.running = true
    }


    Process {
        id: nightOn
        command: ["bash", "-c", "hyprsunset -t 4500 2>/dev/null & disown"]
    }
    Process {
        id: nightOff
        command: ["bash", "-c", "pkill -x hyprsunset 2>/dev/null; exit 0"]
    }
    function toggleNight() {
        root.nightLight = !root.nightLight
        if (root.nightLight) nightOn.running = true
        else nightOff.running = true
    }


    readonly property var btAdapter: Bluetooth.adapters && Bluetooth.adapters.length > 0
        ? Bluetooth.adapters[0] : null
    readonly property bool btPresent: btAdapter !== null
    property bool btEnabled: btPresent && btAdapter.enabled
    onBtEnabledChanged: if (btPresent && btAdapter.enabled !== btEnabled) btAdapter.enabled = btEnabled
    function toggleBt() { btEnabled = !btEnabled }


    property bool wifiEnabled: Networking.wifiEnabled
    onWifiEnabledChanged: if (Networking.wifiEnabled !== wifiEnabled) Networking.wifiEnabled = wifiEnabled
    function toggleWifi() { wifiEnabled = !wifiEnabled }

    Component.onCompleted: readBrightness.run()


    component ToggleRow: Item {
        id: trow
        property string text: ""
        property string icon: ""
        property bool on: false
        property bool enabled: true
        property bool hovered: trowArea.containsMouse
        signal clicked()

        width: (parent.width - parent.spacing) / 2
        height: Metrics.touchTarget
        opacity: trow.enabled ? 1 : 0.4

        activeFocusOnTab: trow.enabled

        // Borderless: "on" is communicated by a soft accent fill plus the
        // accent icon/text takeover below — not by a box outline, which
        // was making every one of these six tiles the loudest thing in the
        // panel regardless of whether it was actually on.
        Rectangle {
            anchors.fill: parent
            radius: Metrics.radiusSm
            color: trow.on ? Colors.accentSoft : (trow.hovered ? Colors.hoverTint : "transparent")
            Behavior on color { ColorAnimation { duration: Motion.fast } }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: -Metrics.ringGap
            radius: Metrics.radiusSm + Metrics.ringGap
            color: "transparent"
            border.color: Colors.focusRing
            border.width: Metrics.ringWidth
            opacity: trow.activeFocus ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: Motion.fast; easing.type: Motion.easeOut } }
        }

        Row {
            id: trowContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Metrics.padSm
            anchors.rightMargin: Metrics.padSm
            anchors.verticalCenter: parent.verticalCenter
            spacing: Metrics.gapXs
            JeriIcon {
                glyph: trow.icon
                size: Metrics.iconSm
                color: trow.on ? Colors.accent : Colors.fgMuted
            }
            Text {
                text: trow.text
                font.family: Typography.family
                font.pixelSize: Typography.sizeXs
                color: trow.on ? Colors.fg : Colors.fgMuted
                elide: Text.ElideRight
                // Derived from the tile's own width rather than a hardcoded
                // 84px — previously fixed regardless of uiScale or tile
                // width, so it would clip or float independently of the
                // rest of the (fully tokenized) layout.
                width: trowContent.width - Metrics.iconSm - Metrics.gapXs
            }
        }
        MouseArea {
            id: trowArea
            anchors.fill: parent
            enabled: trow.enabled
            hoverEnabled: trow.enabled
            cursorShape: Qt.PointingHandCursor
            onPressed: trow.forceActiveFocus()
            onClicked: trow.clicked()
        }

        // These tiles are otherwise mouse-only despite sitting in a
        // keyboard-navigable grid — same gap JeriToggle had before its
        // focus ring was added.
        Keys.onPressed: function(event) {
            if (trow.enabled && (event.key === Qt.Key_Return || event.key === Qt.Key_Space)) {
                trow.clicked()
                event.accepted = true
            }
        }
    }
}