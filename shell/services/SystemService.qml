pragma Singleton
import QtQuick
import Quickshell.Io

Item {






    property int memTotalMiB:  0
    property int memUsedMiB:   0
    property real memPercent:  0.0
    property string uptime:    ""
    property bool ready:       false

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: SystemService.refresh()
    }

    Component.onCompleted: refresh()

    Process {
        id: memProc
        command: ["bash", "-c",
            "awk '/^MemTotal/{t=$2} /^MemAvailable/{a=$2} END{print t\" \"a}' /proc/meminfo"]
        stdout: SplitParser {
            onRead: function(line) {
                var parts = line.trim().split(" ")
                memTotalMiB = Math.round(parseInt(parts[0]) / 1024)
                var avail = parseInt(parts[1]) / 1024
                memUsedMiB  = Math.round(memTotalMiB - avail)
                memPercent  = memTotalMiB > 0 ? Math.round(memUsedMiB / memTotalMiB * 100) : 0
                ready = true
            }
        }
    }

    Process {
        id: uptimeProc
        command: ["cat", "/proc/uptime"]
        stdout: SplitParser {
            onRead: function(line) {
                var secs = Math.floor(parseFloat(line.split(" ")[0]))
                var h = Math.floor(secs / 3600)
                var m = Math.floor((secs % 3600) / 60)
                uptime = h > 0 ? h + "h " + m + "m" : m + "m"
            }
        }
    }

    function refresh() {
        memProc.running = true
        uptimeProc.running = true
    }
}