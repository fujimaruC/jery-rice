import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../theme"
import "../services"
import "../components"




Item {
    id: root
    implicitWidth: 560
    implicitHeight: 180

    property real cpu: 0
    property real temp: 0
    property string netRx: "--"
    property string netTx: "--"

    property var _lastCpu: ({ total: 0, idle: 0 })
    property bool _haveNet: false
    property real _lastRx: 0
    property real _lastTx: 0

    Timer {
        interval: 2000
        running: root.visible
        repeat: true
        onTriggered: perfProc.run()
    }

    Process {
        id: perfProc
        command: ["bash", "-c",
            "awk '/^cpu /{print $2,$3,$4,$5,$6,$7,$8,$9}' /proc/stat; "
            + "for f in /sys/class/thermal/thermal_zone*/temp; do "
            + "[ -r \"$f\" ] && { cat \"$f\"; break; }; done; "
            + "awk 'NR>2{name=$1; gsub(\":\",\"\",name); rx=$2; gsub(\":\",\"\",rx); "
            + "printf \"%s %s %s\\n\", name, rx, $10}' /proc/net/dev"
        ]
        stdout: SplitParser {
            onRead: function(line) {
                var p = line.trim().split(/\s+/)
                if (p.length === 8) {
                    root._handleCpu(p)
                } else if (p.length === 1 && p[0].indexOf(".") >= 0) {
                    root.temp = parseFloat(p[0]) / 1000
                } else if (p.length === 3) {
                    root._handleNet(parseInt(p[1]), parseInt(p[2]))
                }
            }
        }
    }

    function _handleCpu(p) {
        var total = 0
        for (var i = 0; i < 8; i++) total += parseInt(p[i])
        var idle = parseInt(p[3]) + parseInt(p[4])
        var dTotal = total - root._lastCpu.total
        var dIdle = idle - root._lastCpu.idle
        if (root._lastCpu.total > 0 && dTotal > 0)
            root.cpu = Math.max(0, Math.min(1, (dTotal - dIdle) / dTotal))
        root._lastCpu = { total: total, idle: idle }
    }

    function _handleNet(rx, tx) {
        var dt = 2
        if (root._haveNet) {
            root.netRx = root._mb((rx - root._lastRx) / dt)
            root.netTx = root._mb((tx - root._lastTx) / dt)
        }
        root._haveNet = true
        root._lastRx = rx
        root._lastTx = tx
    }

    function _mb(mbps) {
        if (!isFinite(mbps) || mbps < 0) return "--"
        return mbps >= 1 ? mbps.toFixed(1) + " MB/s"
            : (mbps * 1024).toFixed(0) + " KB/s"
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: Metrics.gapLg

        RadialGauge { value: root.cpu; label: "CPU"; color: Colors.accent }
        RadialGauge { value: SystemService.memPercent / 100; label: "RAM"; color: Colors.ok }
        RadialGauge {
            value: root.temp > 0 ? Math.min(1, Math.max(0, (root.temp - 30) / 60)) : 0
            label: "TEMP"
            unit: "°"
            color: root.temp > 70 ? Colors.danger : Colors.accentWarm
        }

        Column {
            Layout.alignment: Qt.AlignVCenter
            spacing: Metrics.gapMd
            Row {
                spacing: Metrics.gapXs
                JeriIcon { glyph: "download"; size: Metrics.iconSm; color: Colors.fgMuted }
                Text {
                    text: root.netRx
                    font.family: Typography.familyMono
                    font.pixelSize: Typography.sizeSm
                    color: Colors.fg
                }
            }
            Row {
                spacing: Metrics.gapXs
                JeriIcon { glyph: "upload"; size: Metrics.iconSm; color: Colors.fgMuted }
                Text {
                    text: root.netTx
                    font.family: Typography.familyMono
                    font.pixelSize: Typography.sizeSm
                    color: Colors.fg
                }
            }
            Text {
                text: SystemService.uptime
                font.family: Typography.familyMono
                font.pixelSize: Typography.sizeSm
                color: Colors.fgMuted
            }
        }
    }

    Component.onCompleted: perfProc.run()
}